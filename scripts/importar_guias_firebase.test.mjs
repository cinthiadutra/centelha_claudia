import assert from "node:assert/strict";
import test from "node:test";

import { prepareGuideUpdates } from "./importar_guias_firebase.mjs";

test("mapeia as sete falanges e associa cadastro ignorando zeros à esquerda", () => {
    const firebaseMediums = {
        "0002": {
            id: "0002",
            guides: [
                { name: "Vovó Rosa", phalanx: "Preto-velhos e Preta-velhas" },
                { name: "Mestre Tião", phalanx: "Baianos e Baianas" },
                { name: "Cabocla Inoã", phalanx: "Caboclos e Caboclas" },
                { name: "Zé do Cais", phalanx: "Malandros e Malandras" },
                { name: "Ramiro", phalanx: "Ciganos e Ciganas" },
                { name: "Zé do Peixe", phalanx: "Marinheiros" },
                { name: "PG Rosa Vermelha", phalanx: "Exus e Pombogiras" },
            ],
        },
    };

    const result = prepareGuideUpdates(firebaseMediums, [{ cadastro: "2" }]);

    assert.equal(result.updates.length, 1);
    assert.equal(result.updates[0].cadastro, "2");
    assert.deepEqual(result.updates[0].fields, {
        nome_pv: "VOVÓ ROSA",
        nome_bai: "MESTRE TIÃO",
        nome_cab: "CABOCLA INOÃ",
        nome_mal: "ZÉ DO CAIS",
        nome_cig: "RAMIRO",
        nome_mar: "ZÉ DO PEIXE",
        nome_pr: "PG ROSA VERMELHA",
    });
});

test("importa A CONFIRMAR e grava null quando o Firebase não tem nome", () => {
    const result = prepareGuideUpdates({
        "0002": {
            id: "0002",
            guides: [
                { name: "A CONFIRMAR", phalanx: "Preto-velhos e Preta-velhas" },
                { name: "Cabocla Jurema", phalanx: "Caboclos e Caboclas" },
                { name: null, phalanx: "Marinheiros" },
            ],
        },
    }, [{ cadastro: "2" }]);

    assert.equal(result.updates.length, 1);
    assert.deepEqual(result.updates[0].fields, {
        nome_pv: "A CONFIRMAR",
        nome_cab: "CABOCLA JUREMA",
        nome_mar: null,
    });
    assert.equal(result.placeholdersImported, 1);
    assert.equal(result.nullNamesImported, 1);
});

test("usa a chave do objeto mediums quando o campo id está ausente", () => {
    const result = prepareGuideUpdates({
        "0003": {
            guides: [{ name: "Caboclo Jurema", phalanx: "Caboclos e Caboclas" }],
        },
    }, [{ cadastro: "3" }]);

    assert.equal(result.updates.length, 1);
    assert.equal(result.updates[0].cadastro, "3");
    assert.deepEqual(result.updates[0].fields, { nome_cab: "CABOCLO JUREMA" });
});

test("ignora códigos sem correspondência e cadastros ambíguos", () => {
    const firebaseMediums = {
        "0002": {
            id: "0002",
            guides: [{ name: "Guia", phalanx: "Marinheiros" }],
        },
        "0003": {
            id: "0003",
            guides: [{ name: "Guia", phalanx: "Marinheiros" }],
        },
    };

    const result = prepareGuideUpdates(firebaseMediums, [
        { cadastro: "2" },
        { cadastro: "0002" },
    ]);

    assert.equal(result.updates.length, 0);
    assert.equal(result.ambiguousMembers, 1);
    assert.equal(result.unmatchedMediums, 1);
});