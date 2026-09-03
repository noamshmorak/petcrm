-- Follow-up fix: hamster orders with no explicit quantity in the note.
-- Per Noam (2026-09-03): "אוגרים תמיד זה 160" - unqualified "אוגרים" is always priced at 160,
-- regardless of the ambiguous wording in the original note. These two orders were left
-- unpriced by the main backfill (price_backfill.sql) for exactly this reason.
-- Safe to re-run: only touches rows where total_price IS NULL.

BEGIN;

UPDATE ad_completed_orders
SET
  total_price = 160,
  raw = COALESCE(raw, '{}'::jsonb) || jsonb_build_object(
    'price_estimated', true,
    'price_estimated_status', 'full',
    'price_estimated_at', now()::text,
    'price_estimated_by', 'ai_backfill_2026-09-03_hamster_rule'
  )
WHERE phone1 = '0548471501'
  AND (raw->>'historical_note_title') = 'בית ים (04.02)'
  AND (raw->>'listDate') = 'Feb 4'
  AND total_price IS NULL;

UPDATE ad_completed_orders
SET
  total_price = 160,
  raw = COALESCE(raw, '{}'::jsonb) || jsonb_build_object(
    'price_estimated', true,
    'price_estimated_status', 'full',
    'price_estimated_at', now()::text,
    'price_estimated_by', 'ai_backfill_2026-09-03_hamster_rule'
  )
WHERE phone1 = '0583234823'
  AND (raw->>'historical_note_title') = 'ירושלים 17'
  AND (raw->>'listDate') = 'Jun 10'
  AND total_price IS NULL;

COMMIT;

-- Verification:
-- SELECT count(*) FILTER (WHERE total_price IS NOT NULL) AS priced, count(*) AS total FROM ad_completed_orders;
