/**
 * Clone các "Tự động hóa theo mẫu (hệ cũ)" → thực thể DraftAutomation (hệ mới).
 *
 * NGUYÊN TẮC AN TOÀN (theo yêu cầu):
 *  - CHỈ TẠO THÊM bản mới, TẤT CẢ ở trạng thái TẠM DỪNG (PAUSED / tắt).
 *  - KHÔNG đụng gì tới hệ cũ: template.data.automation giữ nguyên y chang,
 *    engine/cron cũ vẫn chạy như trước. Việc bật bản mới + tắt bản cũ do
 *    từng chủ sở hữu tự làm sau.
 *  - Idempotent: chạy lại nhiều lần không nhân đôi (bỏ qua template đã clone).
 *
 * Chạy:
 *   npx ts-node prisma/migrate-legacy-automations.ts            # DRY RUN (không ghi)
 *   npx ts-node prisma/migrate-legacy-automations.ts --commit   # ghi thật
 */
import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';
import {
  PrismaClient,
  DraftAutomationSourceType,
  DraftAutomationScheduleType,
  DraftAutomationRunMode,
  DraftAutomationPublishMode,
  DraftAutomationStatus,
} from '../src/generated/prisma';

const COMMIT = process.argv.includes('--commit');
const MARKER = '[migrated-from-legacy]';

const friendlyName = (name: string): string =>
  name?.split('|').pop()?.trim() || name || 'Mẫu';

async function main() {
  const pool = new pg.Pool({
    connectionString: process.env.DATABASE_URL as string,
  });
  const prisma = new PrismaClient({ adapter: new PrismaPg(pool) });
  await prisma.$connect();

  console.log(
    `\n=== Clone Tự động hóa (hệ cũ → mới) — ${COMMIT ? 'GHI THẬT (--commit)' : 'DRY RUN (không ghi)'} ===\n`,
  );

  // 1) Lấy toàn bộ template còn sống có automation.enabled = true (hệ cũ).
  const templates = await prisma.templateCampaign.findMany({
    where: { deletedAt: null },
    select: { id: true, name: true, data: true, createdById: true },
  });
  const legacy = templates.filter(
    (t) => (t.data as any)?.automation?.enabled === true,
  );

  // 2) Map tên chủ sở hữu (TemplateCampaign không có relation User → tra riêng).
  const ownerIds = [
    ...new Set(legacy.map((t) => t.createdById).filter(Boolean) as string[]),
  ];
  const users = ownerIds.length
    ? await prisma.user.findMany({
        where: { id: { in: ownerIds } },
        select: { id: true, name: true, email: true },
      })
    : [];
  const ownerName = new Map(
    users.map((u) => [u.id, u.name || u.email || 'Không rõ']),
  );

  console.log(`Tìm thấy ${legacy.length} automation hệ cũ (enabled=true).\n`);

  let created = 0;
  let skipped = 0;

  for (const t of legacy) {
    const a = (t.data as any).automation;
    const owner = (t.createdById && ownerName.get(t.createdById)) || 'Không rõ';
    const name = `${friendlyName(t.name)} · ${owner}`;

    // Idempotent: đã clone template này chưa? (nhận diện qua marker trong mô tả)
    const existing = await prisma.draftAutomation.findFirst({
      where: {
        templateId: t.id,
        deletedAt: null,
        description: { contains: MARKER },
      },
      select: { id: true },
    });
    if (existing) {
      console.log(`⏭  BỎ QUA (đã clone: ${existing.id})  ${name}`);
      skipped++;
      continue;
    }

    const conditions: Record<string, unknown> = {
      folderIds: a.folderId ? [a.folderId] : [],
      includeSubfolders: false, // hệ cũ không gộp thư mục con → giữ đúng
      cidRequired: true, // engine luôn yêu cầu CID
      videoCount: Number(a.videoCount) || 0,
      imageCount: Number(a.imageCount) || 0,
    };
    if (a.nameRule) conditions.nameRule = a.nameRule;
    if (a.assetCreatedAfter) conditions.assetCreatedAfter = a.assetCreatedAfter;
    if (a.slotRules) conditions.slotRules = a.slotRules;

    const publishMode =
      a.publishMode === 'PUBLISH_IMMEDIATELY'
        ? DraftAutomationPublishMode.PUBLISH_IMMEDIATELY
        : DraftAutomationPublishMode.DRAFT_ONLY;

    const payload = {
      name,
      description: `${MARKER} Chuyển từ Tự động hóa theo mẫu (hệ cũ). Bản cũ vẫn giữ nguyên; bật bản này để dùng hệ mới.`,
      sourceType: DraftAutomationSourceType.TEMPLATE,
      templateId: t.id,
      folderId: a.folderId ?? null,
      conditions: conditions as any,
      scheduleType: DraftAutomationScheduleType.CRON,
      intervalMinutes: a.intervalMinutes ?? null,
      cronExpression: a.cronExpression ?? null,
      timezone: a.timezone ?? null,
      runMode:
        a.runMode === 'ONCE'
          ? DraftAutomationRunMode.ONCE
          : DraftAutomationRunMode.LOOP,
      publishMode,
      status: DraftAutomationStatus.PAUSED, // LUÔN tắt — chủ sở hữu tự bật
      accountId: (t.data as any)?.ad_account_id ?? null,
      createdById: t.createdById ?? null,
      lastRunAt: a.lastRunAt ? new Date(a.lastRunAt) : null,
    };

    const flag =
      publishMode === DraftAutomationPublishMode.PUBLISH_IMMEDIATELY
        ? ' ⚠️ĐĂNG-META'
        : '';
    console.log(`${COMMIT ? '✅ TẠO' : '📝 SẼ TẠO'}  ${name}${flag}`);
    console.log(
      `     mẫu=${t.id}  chủ=${owner}  đăng=${publishMode}  lịch=${payload.cronExpression}  chạy=${payload.runMode}  video=${conditions.videoCount} ảnh=${conditions.imageCount}  folder=${a.folderId ?? '—'}  → trạng thái=PAUSED`,
    );

    if (COMMIT) {
      const row = await prisma.draftAutomation.create({ data: payload as any });
      console.log(`     → đã tạo ${row.id} (TẠM DỪNG)`);
    }
    created++;
  }

  console.log(
    `\n${COMMIT ? '' : '[DRY RUN] '}Xong. ${created} ${COMMIT ? 'đã tạo' : 'sẽ tạo'}, ${skipped} bỏ qua (đã clone trước đó).`,
  );
  if (!COMMIT) {
    console.log('→ Chạy lại kèm  --commit  để ghi thật.\n');
  } else {
    console.log(
      '→ Tất cả bản mới đang TẠM DỪNG. Hệ cũ KHÔNG đổi. Báo từng chủ bật bản mới + tắt bản cũ tương ứng.\n',
    );
  }

  await prisma.$disconnect();
  await pool.end();
}

main().catch((e) => {
  console.error('LỖI:', e);
  process.exit(1);
});
