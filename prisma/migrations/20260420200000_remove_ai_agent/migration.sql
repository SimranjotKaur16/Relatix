-- Drop any RolePermission rows referencing the removed aiAgent resource before recreating the enum type.
DELETE FROM "RolePermission" WHERE "resource"::text = 'aiAgent';

-- AlterEnum
BEGIN;
CREATE TYPE "Resource_new" AS ENUM ('contacts', 'deals', 'organizations', 'services', 'users', 'company', 'tasks', 'api', 'auditLog');
ALTER TABLE "RolePermission" ALTER COLUMN "resource" TYPE "Resource_new" USING ("resource"::text::"Resource_new");
ALTER TYPE "Resource" RENAME TO "Resource_old";
ALTER TYPE "Resource_new" RENAME TO "Resource";
DROP TYPE "public"."Resource_old";
COMMIT;

-- AlterTable
ALTER TABLE "Subscription" DROP COLUMN "plan";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "agentGatewayToken",
DROP COLUMN "agentHooksToken",
DROP COLUMN "crmApiKey",
DROP COLUMN "crmApiKeyId",
DROP COLUMN "flyMachineId",
DROP COLUMN "flyVolumeId";

-- DropEnum
DROP TYPE "SubscriptionPlan";
