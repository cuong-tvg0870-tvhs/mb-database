import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../generated/prisma';
import pg from 'pg';

export class PrismaService extends PrismaClient {
  constructor() {
    const pool = new pg.Pool({
      connectionString: process.env.DATABASE_URL as string,
    });
    const adapter = new PrismaPg(pool);
    super({ adapter });
  }

  async onModuleInit() {
    await this.$connect();
    console.log('[PrismaService] Connected to PostgreSQL');
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
