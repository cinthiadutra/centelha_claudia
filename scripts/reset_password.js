#!/usr/bin/env node

/**
 * Script de Reset de Senha - Centelha Divina
 * 
 * Como usar:
 * node reset_password.js cinthiadutra@gmail.com nova_senha_123
 */

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Cores para o terminal
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
};

console.log(`${colors.blue}🔐 Script de Reset de Senha - Centelha Divina${colors.reset}\n`);

// Pegar argumentos da linha de comando
const email = process.argv[2];
const novaSenha = process.argv[3];

if (email && novaSenha) {
  resetPassword(email, novaSenha);
} else {
  // Modo interativo
  rl.question('Digite o email: ', (emailInput) => {
    rl.question('Digite a nova senha: ', (senhaInput) => {
      rl.close();
      resetPassword(emailInput.trim(), senhaInput.trim());
    });
  });
}

function resetPassword(email, senha) {
  console.log(`\n${colors.yellow}📝 Processando reset de senha...${colors.reset}`);
  console.log(`Email: ${email}`);
  
  if (senha.length < 6) {
    console.log(`${colors.red}❌ Erro: Senha deve ter no mínimo 6 caracteres!${colors.reset}`);
    process.exit(1);
  }

  // Instruções para executar no Supabase
  console.log(`\n${colors.blue}📋 Execute o seguinte SQL no Supabase Dashboard:${colors.reset}\n`);
  
  const sql = `UPDATE auth.users
SET 
  encrypted_password = crypt('${senha}', gen_salt('bf')),
  updated_at = NOW()
WHERE email = '${email}';`;

  console.log(colors.green + sql + colors.reset);
  
  console.log(`\n${colors.yellow}📍 Passos:${colors.reset}`);
  console.log('1. Acesse: https://supabase.com/dashboard');
  console.log('2. Selecione seu projeto');
  console.log('3. Vá em "SQL Editor"');
  console.log('4. Cole o comando SQL acima');
  console.log('5. Clique em "Run"');
  
  console.log(`\n${colors.green}✅ Depois você poderá fazer login com:${colors.reset}`);
  console.log(`   Email: ${email}`);
  console.log(`   Senha: ${senha}`);
  
  process.exit(0);
}
