-- AlterTable
ALTER TABLE "User" ADD COLUMN "onboardingWizardCompletedAt" TIMESTAMP(3);

-- Backfill: existing users have already completed the wizard
UPDATE "User" SET "onboardingWizardCompletedAt" = "createdAt" WHERE "onboardingWizardCompletedAt" IS NULL;
