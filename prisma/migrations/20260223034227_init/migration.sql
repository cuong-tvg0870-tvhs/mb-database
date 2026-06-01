-- AddForeignKey
ALTER TABLE "TemplateCampaign" ADD CONSTRAINT "TemplateCampaign_reference_id_fkey" FOREIGN KEY ("reference_id") REFERENCES "SystemCampaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;
