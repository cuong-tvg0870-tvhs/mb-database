const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const sourceSchemaPath = path.resolve(__dirname, 'prisma/schema.prisma');

if (!fs.existsSync(sourceSchemaPath)) {
  console.error(`[Error] Source schema not found at: ${sourceSchemaPath}`);
  process.exit(1);
}

console.log(`[Info] Reading source schema from: ${sourceSchemaPath}`);
const sourceSchema = fs.readFileSync(sourceSchemaPath, 'utf8');

// Strip out the output line from the generator client block
const cleanedSchema = sourceSchema.replace(/generator\s+client\s*{[^}]*}/g, (match) => {
  return match
    .split('\n')
    .filter(line => !/^\s*output\s*=/.test(line))
    .join('\n');
});

const projects = [
  { name: 'mb-ads', path: '../mb-ads' },
  { name: 'mb-batch', path: '../mb-batch' }
];

let syncCount = 0;

for (const project of projects) {
  const projectAbsPath = path.resolve(__dirname, project.path);
  if (!fs.existsSync(projectAbsPath)) {
    console.warn(`[Warning] Project folder for ${project.name} not found at: ${projectAbsPath}. Skipping.`);
    continue;
  }

  const prismaDir = path.join(projectAbsPath, 'prisma');
  if (!fs.existsSync(prismaDir)) {
    console.log(`[Info] Creating prisma directory in ${project.name}...`);
    fs.mkdirSync(prismaDir, { recursive: true });
  }

  const destSchemaPath = path.join(prismaDir, 'schema.prisma');
  fs.writeFileSync(destSchemaPath, cleanedSchema, 'utf8');
  console.log(`[Success] Cloned schema.prisma to ${project.name}`);
  syncCount++;

  // Run prisma generate in the destination project if node_modules is present
  const nodeModulesPath = path.join(projectAbsPath, 'node_modules');
  if (fs.existsSync(nodeModulesPath)) {
    console.log(`[Info] Running 'npx prisma generate' in ${project.name}...`);
    try {
      execSync('npx prisma generate', { cwd: projectAbsPath, stdio: 'inherit' });
      console.log(`[Success] Generated Prisma client in ${project.name}`);
    } catch (err) {
      console.error(`[Error] Failed to generate Prisma client in ${project.name}:`, err.message);
    }
  } else {
    console.log(`[Info] node_modules not found in ${project.name}. Skipping Prisma client generation.`);
  }
}

console.log(`[Info] Schema synchronization complete. Synced to ${syncCount} project(s).`);
