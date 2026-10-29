-- Remove any leftover tasks of the obsolete type.
DELETE FROM "Task" WHERE "type" = 'companyOnboarding';

-- Drop audit-log rows that reference those tasks (event payload carries the type).
DELETE FROM "AuditLog"
WHERE "event" IN ('task.created', 'task.updated', 'task.deleted')
  AND ("eventData"::jsonb -> 'payload' ->> 'type') = 'companyOnboarding';

-- Drop the `companyOnboarding` value from the TaskType enum.
ALTER TYPE "TaskType" RENAME TO "TaskType_old";

CREATE TYPE "TaskType" AS ENUM ('userPendingAuthorization', 'custom');

ALTER TABLE "Task"
  ALTER COLUMN "type" TYPE "TaskType"
  USING ("type"::text::"TaskType");

DROP TYPE "TaskType_old";
