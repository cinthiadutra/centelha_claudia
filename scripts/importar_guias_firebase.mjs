import { readFile } from "node:fs/promises";
import { pathToFileURL } from "node:url";

const phalanxColumns = new Map([
    ["preto-velhos e preta-velhas", "nome_pv"],
    ["baianos e baianas", "nome_bai"],
    ["caboclos e caboclas", "nome_cab"],
    ["marinheiros", "nome_mar"],
    ["malandros e malandras", "nome_mal"],
    ["ciganos e ciganas", "nome_cig"],
    ["exus e pombogiras", "nome_pr"],
]);

function normalizePhalanx(value) {
    return String(value ?? "")
        .normalize("NFD")
        .replace(/\p{Diacritic}/gu, "")
        .trim()
        .replace(/\s+/g, " ")
        .toLowerCase();
}

function normalizeRegistration(value) {
    const registration = String(value ?? "").trim();
    if (!/^\d+$/.test(registration)) return "";
    return registration.replace(/^0+(?=\d)/, "");
}

function isRecord(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value);
}

export function prepareGuideUpdates(firebaseMediums, memberRows) {
    if (!isRecord(firebaseMediums)) {
        throw new TypeError("O export não contém o objeto mediums.");
    }

    const membersByRegistration = new Map();
    for (const row of memberRows) {
        const registration = String(row?.cadastro ?? "").trim();
        const normalized = normalizeRegistration(registration);
        if (!normalized) continue;
        const registrations = membersByRegistration.get(normalized) ?? [];
        registrations.push(registration);
        membersByRegistration.set(normalized, registrations);
    }

    const result = {
        updates: [],
        unmatchedMediums: 0,
        ambiguousMembers: 0,
        ambiguousGuides: 0,
        placeholdersImported: 0,
        nullNamesImported: 0,
        unknownPhalanxes: 0,
        emptyGuideLists: 0,
        invalidMediums: 0,
    };
    const seenMediumIds = new Set();

    for (const [firebaseKey, medium] of Object.entries(firebaseMediums)) {
        if (!isRecord(medium)) {
            result.invalidMediums++;
            continue;
        }

        const mediumId = String(medium.id ?? firebaseKey).trim();
        const normalizedId = normalizeRegistration(mediumId);
        if (!normalizedId || seenMediumIds.has(normalizedId)) {
            result.invalidMediums++;
            continue;
        }
        seenMediumIds.add(normalizedId);

        const matchingRegistrations = membersByRegistration.get(normalizedId) ?? [];
        if (matchingRegistrations.length === 0) {
            result.unmatchedMediums++;
            continue;
        }
        if (matchingRegistrations.length !== 1) {
            result.ambiguousMembers++;
            continue;
        }

        if (!Array.isArray(medium.guides)) {
            result.emptyGuideLists++;
            continue;
        }

        const guidesByColumn = new Map();
        let hasConflictingGuide = false;

        for (const guide of medium.guides) {
            if (!isRecord(guide)) continue;
            const column = phalanxColumns.get(normalizePhalanx(guide.phalanx));
            if (!column) {
                result.unknownPhalanxes++;
                continue;
            }

            const name = String(guide.name ?? "").trim();
            let normalizedName = name
                ? name.toLocaleUpperCase("pt-BR")
                : null;
            if (name && normalizePhalanx(name) === "a confirmar") {
                normalizedName = "A CONFIRMAR";
                result.placeholdersImported++;
            }
            if (normalizedName === null) result.nullNamesImported++;

            if (guidesByColumn.has(column)) {
                const existingName = guidesByColumn.get(column);
                if (existingName === null && normalizedName !== null) {
                    guidesByColumn.set(column, normalizedName);
                    continue;
                }
                if (normalizedName === null || existingName === normalizedName) {
                    continue;
                }
                hasConflictingGuide = true;
                break;
            }
            guidesByColumn.set(column, normalizedName);
        }

        if (hasConflictingGuide) {
            result.ambiguousGuides++;
            continue;
        }
        if (guidesByColumn.size === 0) {
            result.emptyGuideLists++;
            continue;
        }

        result.updates.push({
            cadastro: matchingRegistrations[0],
            fields: Object.fromEntries(guidesByColumn),
        });
    }

    return result;
}

async function fetchMemberRegistrations(supabaseUrl, serviceKey) {
    const registrations = [];
    const pageSize = 1000;

    for (let offset = 0; ; offset += pageSize) {
        const query = new URLSearchParams({
            select: "cadastro",
            order: "id.asc",
            offset: String(offset),
            limit: String(pageSize),
        });
        const response = await fetch(
            `${supabaseUrl}/rest/v1/membros_historico?${query}`,
            {
                headers: {
                    apikey: serviceKey,
                    Authorization: `Bearer ${serviceKey}`,
                },
            },
        );
        if (!response.ok) {
            throw new Error(
                `Falha ao consultar membros_historico (HTTP ${response.status}).`,
            );
        }

        const page = await response.json();
        registrations.push(...page);
        if (page.length < pageSize) break;
    }

    return registrations;
}

async function applyGuideUpdates(supabaseUrl, serviceKey, updates) {
    let updated = 0;
    for (const update of updates) {
        const query = new URLSearchParams({
            cadastro: `eq.${update.cadastro}`,
            select: "id",
        });
        const response = await fetch(
            `${supabaseUrl}/rest/v1/membros_historico?${query}`,
            {
                method: "PATCH",
                headers: {
                    apikey: serviceKey,
                    Authorization: `Bearer ${serviceKey}`,
                    "Content-Type": "application/json",
                    Prefer: "return=representation",
                },
                body: JSON.stringify(update.fields),
            },
        );
        if (!response.ok) {
            throw new Error(
                `Falha ao atualizar um cadastro (HTTP ${response.status}).`,
            );
        }
        const changedRows = await response.json();
        if (changedRows.length !== 1) {
            throw new Error(
                "A atualização não alterou exatamente um membro; interrompendo a importação.",
            );
        }
        updated++;
    }
    return updated;
}

async function main() {
    const args = process.argv.slice(2);
    const apply = args.includes("--apply");
    const jsonPath = args.find((argument) => argument !== "--apply");
    if (!jsonPath) {
        throw new Error(
            "Uso: node scripts/importar_guias_firebase.mjs <export.json> [--apply]",
        );
    }

    const supabaseUrl = process.env.SUPABASE_URL?.replace(/\/+$/, "");
    const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
    if (!supabaseUrl || !serviceKey) {
        throw new Error("Defina SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY no ambiente.");
    }

    const firebaseExport = JSON.parse(await readFile(jsonPath, "utf8"));
    const memberRegistrations = await fetchMemberRegistrations(
        supabaseUrl,
        serviceKey,
    );
    const result = prepareGuideUpdates(
        firebaseExport.mediums,
        memberRegistrations,
    );

    console.log(JSON.stringify({
        firebaseMediums: Object.keys(firebaseExport.mediums ?? {}).length,
        memberUpdatesPrepared: result.updates.length,
        unmatchedMediums: result.unmatchedMediums,
        ambiguousMembers: result.ambiguousMembers,
        ambiguousGuides: result.ambiguousGuides,
        placeholdersImported: result.placeholdersImported,
        nullNamesImported: result.nullNamesImported,
        unknownPhalanxes: result.unknownPhalanxes,
        emptyGuideLists: result.emptyGuideLists,
        invalidMediums: result.invalidMediums,
        mode: apply ? "apply" : "preview",
    }, null, 2));

    if (!apply) {
        console.log("Prévia concluída; nenhum dado foi alterado. Use --apply para gravar.");
        return;
    }

    const updated = await applyGuideUpdates(
        supabaseUrl,
        serviceKey,
        result.updates,
    );
    console.log(`Importação concluída: ${updated} membros atualizados.`);
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) {
    await main();
}