import { prisma } from '@/lib/prisma'

const bcrypt = require('bcrypt');

async function main() {
  const password = 'RMK@Adm1n#2025!';
  const hashedPassword = await bcrypt.hash(password, 12);

  const adminUser = await prisma.user.upsert({
    where: { email: 'admin@rmkexperts.com' },
    update: {},
    create: {
      name: 'RMK Admin',
      email: 'admin@rmkexperts.com',
      password: hashedPassword,
      role: 'ADMIN',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
  });

  console.log('✅ Admin user seeded successfully with ID:', adminUser.id);
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
