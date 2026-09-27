/*
# Create feedback table (single-tenant, no auth)

1. New Tables
- `feedback`
  - `id` (uuid, primary key)
  - `name` (text, not null) — submitter's name
  - `email` (text, not null) — submitter's email
  - `rating` (int, not null, 1-5) — star rating
  - `message` (text, not null) — feedback message
  - `created_at` (timestamptz, default now())
2. Security
- Enable RLS on `feedback`.
- Allow anon + authenticated to insert (public feedback form).
- Allow anon + authenticated to read (so the app and Supabase dashboard can view).
*/

CREATE TABLE IF NOT EXISTS feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  message text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE feedback ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_feedback" ON feedback;
CREATE POLICY "anon_select_feedback" ON feedback FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_feedback" ON feedback;
CREATE POLICY "anon_insert_feedback" ON feedback FOR INSERT
  TO anon, authenticated WITH CHECK (true);
