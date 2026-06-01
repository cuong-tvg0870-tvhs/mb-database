// prisma/seed.ts
import 'dotenv/config';
import { PrismaService } from '../src/prisma/prisma.service';

type ItemDef = {
  externalId?: string;
  value: string; // value required because schema has @@unique([categoryId, value])
  name: string;
  label?: string;
  color?: string;
  sortOrder?: number;
  metadata?: any;
  isDefault?: boolean;
  isActive?: boolean;
};

async function seed() {
  const prisma = new PrismaService();

  await prisma.$connect();

  async function upsertCategory(
    key: string,
    name: string,
    description?: string,
    adminId?: string,
  ) {
    const existing = await prisma.dropdownCategory.findUnique({
      where: { key },
    });
    if (existing) {
      // update basic fields if changed
      return prisma.dropdownCategory.update({
        where: { id: existing.id },
        data: {
          name,
          description,
          updatedById: adminId ?? existing.updatedById,
        },
      });
    }
    return prisma.dropdownCategory.create({
      data: {
        key,
        name,
        description,
        createdById: adminId ?? undefined,
        updatedById: adminId ?? undefined,
      },
    });
  }

  /**
   * Upsert item using composite unique (categoryId + value) when possible.
   * Fallback: try find by externalId, then name.
   *
   * Important: color is saved inside metadata.color. When updating we merge metadata.
   */
  async function upsertItem(
    categoryId: string,
    item: ItemDef,
    adminId?: string,
  ) {
    // helper to merge metadata and ensure metadata.color set if item.color provided
    const mergeMetadata = (existingMeta: any, newMeta: any, color?: string) => {
      const merged = { ...(existingMeta ?? {}), ...(newMeta ?? {}) };
      if (color !== undefined) merged.color = color;
      return Object.keys(merged).length ? merged : undefined;
    };

    // 1) Try find by composite unique (categoryId + value)
    if (item.value) {
      const found = await prisma.dropdownItem.findFirst({
        where: { categoryId, value: item.value },
      });
      if (found) {
        const updatedMeta = mergeMetadata(
          found.metadata,
          item.metadata,
          item.color,
        );
        return prisma.dropdownItem.update({
          where: { id: found.id },
          data: {
            externalId: item.externalId ?? found.externalId,
            name: item.name,
            description: item.label ?? found.description,
            sortOrder: item.sortOrder ?? found.sortOrder,
            metadata: updatedMeta,
            isDefault: item.isDefault ?? found.isDefault,
            isActive: item.isActive ?? true,
            updatedById: adminId ?? found.updatedById,
            color: item.color ?? found.color,
          },
        });
      }
    }

    // 2) Try find by externalId if provided
    if (item.externalId) {
      const foundByExt = await prisma.dropdownItem.findFirst({
        where: { categoryId, externalId: item.externalId },
      });
      if (foundByExt) {
        const updatedMeta = mergeMetadata(
          foundByExt.metadata,
          item.metadata,
          item.color,
        );
        return prisma.dropdownItem.update({
          where: { id: foundByExt.id },
          data: {
            value: item.value ?? foundByExt.value,
            name: item.name,
            description: item.label ?? foundByExt.description,
            sortOrder: item.sortOrder ?? foundByExt.sortOrder,
            metadata: updatedMeta,
            isDefault: item.isDefault ?? foundByExt.isDefault,
            isActive: item.isActive ?? true,
            updatedById: adminId ?? foundByExt.updatedById,
          },
        });
      }
    }

    // 3) Try find by name
    const foundByName = await prisma.dropdownItem.findFirst({
      where: { categoryId, name: item.name },
    });
    if (foundByName) {
      const updatedMeta = mergeMetadata(
        foundByName.metadata,
        item.metadata,
        item.color,
      );
      return prisma.dropdownItem.update({
        where: { id: foundByName.id },
        data: {
          externalId: item.externalId ?? foundByName.externalId,
          value: item.value ?? foundByName.value,
          description: item.label ?? foundByName.description,
          sortOrder: item.sortOrder ?? foundByName.sortOrder,
          metadata: updatedMeta,
          isDefault: item.isDefault ?? foundByName.isDefault,
          isActive: item.isActive ?? true,
          updatedById: adminId ?? foundByName.updatedById,
        },
      });
    }

    // 4) Create new
    const createMeta = (() => {
      const m = item.metadata ?? undefined;
      if (item.color !== undefined) {
        return { ...(m ?? {}), color: item.color };
      }
      return m;
    })();

    return prisma.dropdownItem.create({
      data: {
        categoryId,
        externalId: item.externalId ?? undefined,
        value: item.value,
        name: item.name,
        description: item.label ?? undefined,
        sortOrder: item.sortOrder ?? 0,
        metadata: createMeta ?? undefined,
        isDefault: item.isDefault ?? false,
        isActive: item.isActive ?? true,
        createdById: adminId ?? undefined,
        updatedById: adminId ?? undefined,
      },
    });
  }

  try {
    // you used a static adminId earlier — keep it or replace with actual admin id from DB
    const adminId = '1f78291c-00e3-41d5-8967-e7bbe16dc3a3';

    // -----------------------------
    // 1) Campaign Status (add color)
    // -----------------------------
    const campaignStatusDefs: ItemDef[] = [
      {
        value: 'ACTIVE',
        name: 'Active',
        label: 'Active',
        color: 'green',
        sortOrder: 0,
      },
      {
        value: 'PAUSED',
        name: 'Paused',
        label: 'Paused',
        color: 'yellow',
        sortOrder: 1,
      },
      {
        value: 'DELETED',
        name: 'Deleted',
        label: 'Deleted',
        color: 'gray',
        sortOrder: 2,
      },
      {
        value: 'ARCHIVED',
        name: 'Archived',
        label: 'Archived',
        color: 'gray',
        sortOrder: 3,
      },
      {
        value: 'COMPLETED',
        name: 'Completed',
        label: 'Completed',
        color: 'blue',
        sortOrder: 4,
      },
      {
        value: 'NOT_DELIVERING',
        name: 'Not Delivering',
        label: 'Not Delivering',
        color: 'red',
        sortOrder: 5,
      },
      {
        value: 'WITH_ISSUES',
        name: 'With Issues',
        label: 'With Issues',
        color: 'orange',
        sortOrder: 6,
      },
    ];
    const catStatus = await upsertCategory(
      'campaign_status',
      'Campaign Status',
      'Trạng thái chiến dịch',
      adminId,
    );
    for (const it of campaignStatusDefs) {
      await upsertItem(catStatus.id, it, adminId);
    }

    // -----------------------------
    // 2) Campaign Objective (add color)
    // -----------------------------
    const campaignObjectiveDefs: ItemDef[] = [
      {
        value: 'OUTCOME_APP_PROMOTION',
        name: 'App Promotion',
        color: 'green',
        sortOrder: 0,
      },
      {
        value: 'OUTCOME_AWARENESS',
        name: 'Awareness',
        color: 'blue',
        sortOrder: 1,
      },
      {
        value: 'OUTCOME_ENGAGEMENT',
        name: 'Engagement',
        color: 'orange',
        sortOrder: 2,
      },
      { value: 'OUTCOME_LEADS', name: 'Leads', color: 'teal', sortOrder: 3 },
      { value: 'OUTCOME_SALES', name: 'Sales', color: 'red', sortOrder: 4 },
      {
        value: 'OUTCOME_TRAFFIC',
        name: 'Traffic',
        color: 'purple',
        sortOrder: 5,
      },
    ];
    const catObjective = await upsertCategory(
      'campaign_objective',
      'Campaign Objective',
      'Mục tiêu chiến dịch',
      adminId,
    );
    for (const it of campaignObjectiveDefs) {
      await upsertItem(catObjective.id, it, adminId);
    }

    // -----------------------------
    // 3) Optimization Goal (add color)
    // -----------------------------
    const optimizationGoalDefs: ItemDef[] = [
      {
        value: 'LEAD_GENERATION',
        name: 'Lead Generation',
        color: 'green',
        sortOrder: 0,
      },
      {
        value: 'QUALITY_LEAD',
        name: 'Quality Lead',
        color: 'teal',
        sortOrder: 1,
      },
      {
        value: 'LINK_CLICKS',
        name: 'Link Clicks',
        color: 'blue',
        sortOrder: 2,
      },
      {
        value: 'POST_ENGAGEMENT',
        name: 'Post Engagement',
        color: 'purple',
        sortOrder: 3,
      },
      {
        value: 'CONVERSATIONS',
        name: 'Conversations',
        color: 'pink',
        sortOrder: 4,
      },
      { value: 'REACH', name: 'Reach', color: 'yellow', sortOrder: 5 },
      {
        value: 'OFFSITE_CONVERSIONS',
        name: 'Offsite Conversions',
        color: 'gray',
        sortOrder: 6,
      },
    ];
    const catOpt = await upsertCategory(
      'optimization_goal',
      'Optimization Goal',
      'Optimization goal for ads',
      adminId,
    );
    for (const it of optimizationGoalDefs) {
      await upsertItem(catOpt.id, it, adminId);
    }

    // -----------------------------
    // 4) Billing Event (add color)
    // -----------------------------
    const billingEventDefs: ItemDef[] = [
      {
        value: 'IMPRESSIONS',
        name: 'Impressions',
        color: 'blue',
        sortOrder: 0,
      },
      {
        value: 'LINK_CLICKS',
        name: 'Link Clicks',
        color: 'green',
        sortOrder: 1,
      },
      {
        value: 'APP_INSTALLS',
        name: 'App Installs',
        color: 'purple',
        sortOrder: 2,
      },
      {
        value: 'POST_ENGAGEMENT',
        name: 'Post Engagement',
        color: 'orange',
        sortOrder: 3,
      },
    ];
    const catBilling = await upsertCategory(
      'billing_event',
      'Billing Event',
      'Billing event mapping',
      adminId,
    );
    for (const it of billingEventDefs) {
      await upsertItem(catBilling.id, it, adminId);
    }

    // -----------------------------
    // 5) Countries (no color necessary, but you can add if desired)
    // -----------------------------
    const countries: ItemDef[] = [
      { value: 'TH', name: 'Thailand (TH)', sortOrder: 0 },
      { value: 'VN', name: 'Vietnam (VN)', sortOrder: 1 },
      { value: 'BN', name: 'Brunei (BN)', sortOrder: 2 },
      { value: 'KH', name: 'Cambodia (KH)', sortOrder: 3 },
      { value: 'ID', name: 'Indonesia (ID)', sortOrder: 4 },
      { value: 'LA', name: 'Laos (LA)', sortOrder: 5 },
      { value: 'MY', name: 'Malaysia (MY)', sortOrder: 6 },
      { value: 'MM', name: 'Myanmar (MM)', sortOrder: 7 },
      { value: 'PH', name: 'Philippines (PH)', sortOrder: 8 },
      { value: 'SG', name: 'Singapore (SG)', sortOrder: 9 },
      { value: 'UK', name: 'United Kingdom (UK)', sortOrder: 10 },
      { value: 'DE', name: 'Germany (DE)', sortOrder: 11 },
      { value: 'FR', name: 'France (FR)', sortOrder: 12 },
      { value: 'IT', name: 'Italy (IT)', sortOrder: 13 },
      { value: 'ES', name: 'Spain (ES)', sortOrder: 14 },
      { value: 'NL', name: 'Netherlands (NL)', sortOrder: 15 },
      { value: 'SE', name: 'Sweden (SE)', sortOrder: 16 },
      { value: 'CH', name: 'Switzerland (CH)', sortOrder: 17 },
      { value: 'DK', name: 'Denmark (DK)', sortOrder: 18 },
      { value: 'NO', name: 'Norway (NO)', sortOrder: 19 },
      { value: 'FI', name: 'Finland (FI)', sortOrder: 20 },
      { value: 'PL', name: 'Poland (PL)', sortOrder: 21 },
    ];
    const catCountry = await upsertCategory(
      'country',
      'Country',
      'Supported countries',
      adminId,
    );
    for (const it of countries) {
      await upsertItem(catCountry.id, it, adminId);
    }

    console.log('✅ Dropdown seed finished');
  } catch (err) {
    console.error('Seed error', err);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

seed()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => process.exit(0));
