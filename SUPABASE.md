# Supabase Setup

This document records the database schema and edge functions used to power the ArenaOne backend.

## Database Schema (SQL)

Run the following SQL in your Supabase SQL Editor to create the necessary tables and seed the sports data.

```sql
-- Sports: Main categories (NBA, F1, Football, etc.)
create table sports (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null
);

-- Seed defaults
insert into sports (name, slug) values
('Basketball', 'nba'),
('Motorsport', 'f1'),
('Football', 'football'),
('Tennis', 'tennis'),
('Golf', 'golf'),
('Cricket', 'cricket');

-- Leagues: Specific competitions (NBA, Premier League, etc.)
create table leagues (
  id uuid primary key default gen_random_uuid(),
  sport_id uuid references sports(id),
  name text not null,
  season text,
  external_id text
);

-- Events: Individual games or races
create table events (
  id uuid primary key default gen_random_uuid(),
  sport_id uuid references sports(id),
  league_id uuid references leagues(id),
  name text,
  start_time timestamptz,
  status text,
  venue text,
  external_id text unique,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Participants: Teams, players, or drivers
create table participants (
  id uuid primary key default gen_random_uuid(),
  sport_id uuid references sports(id),
  type text, -- team, player, driver
  name text,
  logo text,
  external_id text unique
);

-- Event Participants: Mapping participants to events (for scores and winners)
create table event_participants (
  id uuid primary key default gen_random_uuid(),
  event_id uuid references events(id) on delete cascade,
  participant_id uuid references participants(id),
  score text,
  position integer,
  winner boolean
);
```

## Edge Function: ingest-events (TypeScript)

Deploy this function to Supabase to fetch live and upcoming events from the ESPN API and prefill your tables.

```typescript
import { createClient } from "npm:@supabase/supabase-js@2.31.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"); // or SUPABASE_ANON_KEY

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_KEY");
}

const supabase = createClient(SUPABASE_URL ?? "", SUPABASE_KEY ?? "", {
  auth: { persistSession: false }
});

const SPORTS = [
  { slug: "nba", path: "basketball/nba" },
  { slug: "f1", path: "racing/f1" },
  { slug: "football", path: "soccer/eng.1" },
  { slug: "tennis", path: "tennis/atp" },
  { slug: "golf", path: "golf/pga" },
  { slug: "cricket", path: "cricket/ipl" }
];

Deno.serve(async (req: Request) => {
  try {
    for (const sport of SPORTS) {
      const url = `https://site.api.espn.com/apis/site/v2/sports/${sport.path}/scoreboard`;
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 10_000); // 10s timeout

      let res;
      try {
        res = await fetch(url, { signal: controller.signal });
      } catch (err) {
        console.error("Fetch error for", sport.slug, err);
        clearTimeout(timeout);
        continue;
      }
      clearTimeout(timeout);

      if (!res.ok) {
        console.error("Non-OK response from ESPN for", sport.slug, res.status);
        continue;
      }

      let data: any;
      try {
        data = await res.json();
      } catch (err) {
        console.error("Invalid JSON from ESPN for", sport.slug, err);
        continue;
      }

      if (!data?.events || !Array.isArray(data.events)) {
        console.warn("No events for", sport.slug);
        continue;
      }

      await processEvents(data, sport.slug);
    }

    return new Response(JSON.stringify({ status: "ok", message: "Ingestion complete" }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (err) {
    console.error("Unhandled error in ingestion:", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
});

async function processEvents(data: any, slug: string) {
  for (const event of data.events) {
    try {
      const sportResp = await supabase.from("sports").select("id").eq("slug", slug).limit(1).maybeSingle();
      if (sportResp.error) {
        console.error("Supabase error selecting sport:", sportResp.error);
        continue;
      }
      const sportRow = sportResp.data;
      if (!sportRow?.id) {
        console.warn("No sport row found for slug:", slug);
        continue;
      }

      const eventPayload = {
        sport_id: sportRow.id,
        name: event.name,
        start_time: event.date,
        status: event.status?.type?.name ?? null,
        external_id: event.id
      };

      const eventResp = await supabase
        .from("events")
        .upsert(eventPayload, { onConflict: "external_id", ignoreDuplicates: false })
        .select()
        .limit(1)
        .maybeSingle();

      if (eventResp.error) {
        console.error("Supabase error upserting event:", eventResp.error, "payload:", eventPayload);
        continue;
      }
      const eventRow = eventResp.data;
      if (!eventRow?.id) {
        console.error("Event upsert did not return an id for payload:", eventPayload);
        continue;
      }

      const competitors = event.competitions?.[0]?.competitors ?? [];
      for (const comp of competitors) {
        const participantPayload = {
          sport_id: sportRow.id,
          type: comp.type ?? "team",
          name: comp.team?.displayName ?? comp.athlete?.displayName ?? null,
          logo: comp.team?.logo ?? null,
          external_id: comp.id
        };

        const partResp = await supabase
          .from("participants")
          .upsert(participantPayload, { onConflict: "external_id", ignoreDuplicates: false })
          .select()
          .limit(1)
          .maybeSingle();

        if (partResp.error) {
          console.error("Supabase error upserting participant:", partResp.error, "payload:", participantPayload);
          continue;
        }
        const participant = partResp.data;
        if (!participant?.id) {
          console.error("Participant upsert did not return id:", participantPayload);
          continue;
        }

        const epPayload = {
          event_id: eventRow.id,
          participant_id: participant.id,
          score: comp.score ?? null,
          winner: comp.winner ?? false
        };

        const epResp = await supabase.from("event_participants").upsert(epPayload, { onConflict: ["event_id","participant_id"] });
        if (epResp.error) {
          console.error("Supabase error upserting event_participant:", epResp.error, "payload:", epPayload);
        }
      }
    } catch (err) {
      console.error("Error processing event", event?.id ?? "<unknown>", err);
    }
  }
}
```
