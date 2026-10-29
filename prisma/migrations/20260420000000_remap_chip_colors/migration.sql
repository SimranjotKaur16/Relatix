-- Rename the legacy HeroUI chip-color vocabulary to shadcn's badge variants.
--   old `secondary` -> `info`        (was distinct lavender; restore as blue)
--   old `default`   -> `secondary`   (both rendered grey; unify on one name)
--   old `primary`   -> `default`     (primary-colored filled chip)
--   old `danger`    -> `destructive` (red)
--   `success` / `warning` stay as-is.
--
-- Colors live inside `CustomColumn.options` JSONB. Audit logs snapshot those
-- JSON payloads inside `AuditLog.eventData` — remap both so historical views
-- keep rendering.
--
-- The order below is critical and must cascade bottom-up:
--   1. `secondary -> info`   (must run first, before any new `secondary` is created)
--   2. `default   -> secondary` (creates new `secondary`; safe now that old ones are gone)
--   3. `primary   -> default`   (creates new `default`; safe now that old ones are gone)
--   4. `danger    -> destructive`

UPDATE "CustomColumn"
SET options = regexp_replace(
  regexp_replace(
    regexp_replace(
      regexp_replace(
        options::text,
        '"color"\s*:\s*"secondary"', '"color": "info"', 'g'
      ),
      '"color"\s*:\s*"default"', '"color": "secondary"', 'g'
    ),
    '"color"\s*:\s*"primary"', '"color": "default"', 'g'
  ),
  '"color"\s*:\s*"danger"', '"color": "destructive"', 'g'
)::jsonb
WHERE options IS NOT NULL;

UPDATE "AuditLog"
SET "eventData" = regexp_replace(
  regexp_replace(
    regexp_replace(
      regexp_replace(
        "eventData"::text,
        '"color"\s*:\s*"secondary"', '"color": "info"', 'g'
      ),
      '"color"\s*:\s*"default"', '"color": "secondary"', 'g'
    ),
    '"color"\s*:\s*"primary"', '"color": "default"', 'g'
  ),
  '"color"\s*:\s*"danger"', '"color": "destructive"', 'g'
)::jsonb
WHERE "eventData" IS NOT NULL;
