// prisma/seed.ts
import { Role } from '../src/generated/prisma';
import * as bcrypt from 'bcrypt';
import 'dotenv/config';
import { PrismaService } from '../src/prisma/prisma.service';

const loaihinh = {
  id: '507b2ee7-86e8-4104-9ba3-1fce88f10fd6',
  key: 'LOAI_HINH',
  name: 'Loại Hình',
  description: '',
};
const loai_hinh_items = [
  {
    id: '1af9d0ad-7daf-4e57-8040-7a8a021a9a4d',
    name: 'Re target',
    value: 'RE_TARGET',
  },
  {
    id: 'b068bf11-4d4a-4cb8-b8b0-767add221527',
    name: 'Scale',
    value: 'SCALE',
  },
  {
    id: '206a1f12-679a-473f-81e7-a74b3dc67f97',
    name: 'Testing',
    value: 'TESTING',
  },
  {
    id: 'd6d88b7a-ecc4-4c32-a0fa-8e289b7af94f',
    name: 'Xả Hàng',
    value: 'XA_HANG',
  },
];

async function main() {
  const prisma = new PrismaService();
  await prisma.$connect();

  console.log('🌱 Start seeding (accounts + users + account members)...');

  try {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    // // --- USERS
    // // ---

    await prisma.user.upsert({
      where: { email: 'admin@tvhs.asia' },
      update: {},
      create: {
        role: Role.ADMIN,
        email: 'admin@tvhs.asia',
        name: 'System Admin',
        password: hashedPassword,
      },
    });

    await prisma.user.upsert({
      where: { email: 'managerA@tvhs.asia' },
      update: {},
      create: {
        role: Role.EMPLOYEE,
        email: 'managerA@tvhs.asia',
        name: 'Manager A',
        password: hashedPassword,
      },
    });

    await prisma.user.upsert({
      where: { email: 'managerB@tvhs.asia' },
      update: {},
      create: {
        role: Role.EMPLOYEE,
        email: 'managerB@tvhs.asia',
        name: 'Manager B',
        password: hashedPassword,
      },
    });

    await prisma.user.upsert({
      where: { email: 'editorX@tvhs.asia' },
      update: {},
      create: {
        role: Role.EMPLOYEE,
        email: 'editorX@tvhs.asia',
        name: 'Editor X',
        password: hashedPassword,
      },
    });

    await prisma.dropdownCategory.upsert({
      where: { id: loaihinh.id },
      create: loaihinh,
      update: {},
    });

    for (let index = 0; index < loai_hinh_items.length; index++) {
      const item = loai_hinh_items[index];

      await prisma.dropdownItem.upsert({
        where: { id: item.id, categoryId: loaihinh.id },
        create: {
          id: item.id,
          categoryId: loaihinh.id,
          name: item.name,
          value: item.value,
        },
        update: {},
      });
    }
  } catch (err) {
    console.error('Seed error', err);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }

  console.log('✅ Seeding finished.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {});
