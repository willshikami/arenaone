# Supabase Setup

This document records the database schema and edge functions used to power the ArenaOne backend.

## Database Schema (SQL)

Run the following SQL in your Supabase SQL Editor to create the necessary tables and seed the sports data.

```sql
-- Sports: Main categories (NBA, F1, Football, etc.)
create table sports (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  created_at timestamp default now()
);

-- Seed defaults
insert into sports (name, slug) values
('NBA', 'nba'),
('Formula 1', 'f1'),
('Football', 'football'),
('Tennis', 'tennis'),
('Golf', 'golf'),
('World Rally Championship', 'rally');


-- Participants: Teams or athletes
create table participants (
  id uuid primary key default gen_random_uuid(),
  sport_id uuid references sports(id) on delete cascade,
  external_id text not null,
  type text not null, -- team | athlete
  name text,
  abbreviation text,
  logo text,
  created_at timestamp default now(),
  unique(external_id)
);

-- Events: Individual games or races
create table events (
  id uuid primary key default gen_random_uuid(),
  sport_id uuid references sports(id) on delete cascade,
  external_id text not null,
  name text,
  short_name text,
  season integer,
  start_time timestamptz,
  
  -- Status
  status_type text,
  status_state text, -- pre | in | post
  completed boolean default false,
  is_live boolean default false,
  clock text,
  period integer,
  
  -- Venue
  venue_name text,
  venue_city text,
  venue_country text,
  
  created_at timestamp default now(),
  updated_at timestamp default now(),
  unique(external_id)
);


-- Event Participants: Mapping participants to events (for scores and winners)
create table event_participants (
  id uuid primary key default gen_random_uuid(),
  event_id uuid references events(id) on delete cascade,
  participant_id uuid references participants(id) on delete cascade,

  score text,
  winner boolean,
  home_away text,
  record text,
  seed integer,
  position integer, -- order for F1/Golf
  linescores jsonb,

  created_at timestamp default now(),
  unique(event_id, participant_id)
);
```

## Edge Function: ingest-events (TypeScript)

Deploy this function to Supabase to fetch live and upcoming events from the ESPN API and prefill your tables.

```typescript
import { createClient } from "npm:@supabase/supabase-js@2.31.0";

const SPORTS = [
  { slug: "nba", path: "basketball/nba" },
  { slug: "f1", path: "racing/f1" },
  { slug: "football", path: "soccer/eng.1" },
  { slug: "tennis", path: "tennis/atp" },
  { slug: "golf", path: "golf/pga" },
  { slug: "rally", path: "racing/wrc" },
];

Deno.serve(async (req: Request) => {
  // CORS preflight response - adjust allowed origins as needed for production
  if (req.method === "OPTIONS") {
    const headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      "Access-Control-Allow-Headers": "Authorization, Content-Type",
    };
    return new Response("ok", { status: 204, headers });
  }

  // Basic env validation
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
  const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"); // optional

  if (!SUPABASE_URL) {
    console.error("Missing SUPABASE_URL");
    return new Response(JSON.stringify({ error: "Server misconfiguration: missing SUPABASE_URL" }), { status: 500, headers: { "Content-Type": "application/json" } });
  }
  if (!SUPABASE_ANON_KEY && !SUPABASE_SERVICE_ROLE_KEY) {
    console.error("Missing keys: need SUPABASE_ANON_KEY or SUPABASE_SERVICE_ROLE_KEY");
    return new Response(JSON.stringify({ error: "Server misconfiguration: missing keys" }), { status: 500, headers: { "Content-Type": "application/json" } });
  }

  try {
    // === DIAGNOSTIC & robust header extraction ===
    // Collect headers (header names are lowercased by iteration)
    const headersObj: Record<string, string | null> = {};
    for (const [k, v] of req.headers.entries()) {
      headersObj[k] = v;
    }

    // Try multiple ways to extract Authorization, tolerant to casing
    const rawAuth = req.headers.get("Authorization") ?? req.headers.get("authorization") ?? null;
    const rawAuthMasked = rawAuth ? `${rawAuth.slice(0, 8)}...` : null;
    const split = rawAuth ? rawAuth.split(" ") : [];
    const tokenCandidate = split.length >= 2 && split[0].toLowerCase() === "bearer" ? split.slice(1).join(" ") : null;

    console.info("Authorization header present:", Boolean(rawAuth));
    console.info("Authorization header (masked):", rawAuthMasked);
    console.info("tokenCandidate present:", Boolean(tokenCandidate));

    // Expose a short diagnostic endpoint if requested
    const url = new URL(req.url);
    if (url.searchParams.get("diag") === "1") {
      return new Response(JSON.stringify({
        headers: headersObj,
        authorization_present: Boolean(rawAuth),
        raw_auth_masked: rawAuthMasked,
        token_candidate_present: Boolean(tokenCandidate),
      }, null, 2), { status: 200, headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" } });
    }
    // === end diagnostic ===

    // Choose runtime key:
    // - If an Authorization header exists, we still initialize with anon key but forward the Authorization header so RLS applies.
    // - If no Authorization header and SUPABASE_SERVICE_ROLE_KEY exists, use it for trusted server operations.
    const runtimeKey = rawAuth ? (SUPABASE_ANON_KEY || SUPABASE_SERVICE_ROLE_KEY!) : (SUPABASE_SERVICE_ROLE_KEY ?? SUPABASE_ANON_KEY);

    // If we ended with no runtimeKey, fail early (shouldn't happen due to checks above)
    if (!runtimeKey) {
      console.error("No runtime key available");
      return new Response(JSON.stringify({ error: "Server misconfiguration: no runtime key" }), { status: 500, headers: { "Content-Type": "application/json" } });
    }

    // Create per-request Supabase client with optional forwarded Authorization header
    const supabase = createClient(SUPABASE_URL, runtimeKey, {
      global: {
        headers: {
          // If rawAuth is null, this will be empty string; supabase-js ignores empty Authorization
          Authorization: rawAuth ?? "",
        },
      },
      auth: { persistSession: false },
    });

    // If we extracted a Bearer token, ensure the SDK auth layer uses it
    // supabase.auth.setAuth(token) helps auth helpers rely on the token
    if (tokenCandidate) {
      try {
        // setAuth is synchronous and sets the runtime token for auth calls
        // @ts-ignore - supabase-js types may or may not expose this method depending on version
        supabase.auth.setAuth(tokenCandidate);
        console.info("Set supabase auth token via supabase.auth.setAuth");
      } catch (e) {
        // If setAuth isn't available in this runtime, fallback to leaving Authorization header in global headers
        console.warn("supabase.auth.setAuth failed or not available:", String(e));
      }
    }

    // Optional: log whether we are using service role
    const usingServiceRole = runtimeKey === SUPABASE_SERVICE_ROLE_KEY;
    console.info("Using service role key:", usingServiceRole);

    // Ingestion loop
    for (const sport of SPORTS) {
      const url = `https://site.api.espn.com/apis/site/v2/sports/${sport.path}/scoreboard`;

      const res = await fetch(url);
      if (!res.ok) {
        console.error("Failed fetch:", sport.slug, res.status);
        continue;
      }

      const data = await res.json();
      if (!data?.events) continue;

      await processEvents(data.events, sport.slug, supabase);
    }

    const respHeaders: Record<string, string> = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    return new Response(JSON.stringify({ status: "ok" }), { status: 200, headers: respHeaders });
  } catch (err) {
    console.error("Ingestion error:", err);
    return new Response(JSON.stringify({ error: String(err) }), { status: 500, headers: { "Content-Type": "application/json" } });
  }
});

async function processEvents(events: any[], slug: string, supabase: ReturnType<typeof createClient>) {
  const { data: sportRow, error: sportErr } = await supabase
    .from("sports")
    .select("id")
    .eq("slug", slug)
    .maybeSingle();

  if (sportErr) {
    console.error("Error fetching sport row:", sportErr);
    return;
  }

  if (!sportRow?.id) {
    console.error("Missing sport:", slug);
    return;
  }

  for (const event of events) {
    const competition = event.competitions?.[0];
    const venue = competition?.venue;
    const status = event.status?.type;

    const eventPayload = {
      sport_id: sportRow.id,
      external_id: event.id,
      name: event.name,
      short_name: event.shortName ?? null,
      season: event.season?.year ?? null,
      start_time: event.date ?? null,

      status_type: status?.name ?? null,
      status_state: status?.state ?? null,
      completed: status?.completed ?? false,
      is_live: status?.state === "in",
      clock: event.status?.displayClock ?? null,
      period: event.status?.period ?? null,

      venue_name: venue?.fullName ?? null,
      venue_city: venue?.address?.city ?? null,
      venue_country: venue?.address?.country ?? null,

      updated_at: new Date().toISOString(),
    };

    const { data: eventRow, error: eventErr } = await supabase
      .from("events")
      .upsert(eventPayload, { onConflict: "external_id" })
      .select()
      .maybeSingle();

    if (eventErr) {
      console.error("Upsert event error:", eventErr, "payload:", eventPayload);
      continue;
    }

    if (!eventRow?.id) continue;

    const competitors = competition?.competitors ?? [];

    for (const comp of competitors) {
      const participantPayload = {
        sport_id: sportRow.id,
        external_id: comp.id,
        type: comp.type ?? "team",
        name: comp.team?.displayName ?? comp.athlete?.displayName ?? null,
        abbreviation: comp.team?.abbreviation ?? null,
        logo: comp.team?.logo ?? null,
      };

      const { data: participant, error: participantErr } = await supabase
        .from("participants")
        .upsert(participantPayload, { onConflict: "external_id" })
        .select()
        .maybeSingle();

      if (participantErr) {
        console.error("Upsert participant error:", participantErr, "payload:", participantPayload);
        continue;
      }

      if (!participant?.id) continue;

      const epPayload = {
        event_id: eventRow.id,
        participant_id: participant.id,
        score: comp.score ?? null,
        winner: comp.winner ?? false,
        home_away: comp.homeAway ?? null,
        record: comp.records?.map((r: any) => r.summary).join(" | ") ?? null,
        seed: comp.seed ?? null,
        position: comp.order ?? null,
        linescores: comp.linescores ?? null,
      };

      const { error: epErr } = await supabase
        .from("event_participants")
        .upsert(epPayload, { onConflict: ["event_id", "participant_id"] });

      if (epErr) {
        console.error("Upsert event_participants error:", epErr, "payload:", epPayload);
      }
    }
  }
}
```
```typescript v2

import { createClient } from "npm:@supabase/supabase-js@2.31.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

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
];

Deno.serve(async (_req: Request) => {
  try {
    for (const sport of SPORTS) {
      const url = `https://site.api.espn.com/apis/site/v2/sports/${sport.path}/scoreboard`;
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 10_000);

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
      const sportResp = await supabase
        .from("sports")
        .select("id")
        .eq("slug", slug)
        .limit(1)
        .maybeSingle();

      if (sportResp.error) {
        console.error("Supabase error selecting sport:", sportResp.error);
        continue;
      }

      const sportRow = sportResp.data;
      if (!sportRow?.id) {
        console.warn("No sport row found for slug:", slug);
        continue;
      }

      const competition = event.competitions?.[0];
      const venue = competition?.venue;
      const status = event.status?.type;

      const eventPayload = {
        sport_id: sportRow.id,
        external_id: event.id,
        name: event.name,
        short_name: event.shortName ?? null,
        season: event.season?.year ?? null,
        start_time: event.date ?? null,

        status_type: status?.name ?? null,
        status_state: status?.state ?? null,
        completed: status?.completed ?? false,
        is_live: status?.state === "in",
        clock: event.status?.displayClock ?? null,
        period: event.status?.period ?? null,

        venue_name: venue?.fullName ?? null,
        venue_city: venue?.address?.city ?? null,
        venue_country: venue?.address?.country ?? null,

        updated_at: new Date().toISOString(),
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
      if (!eventRow?.id) continue;

      const competitors = competition?.competitors ?? [];

      for (const comp of competitors) {
        const participantPayload = {
          sport_id: sportRow.id,
          external_id: comp.id,
          type: comp.type ?? "team",
          name: comp.team?.displayName ?? comp.athlete?.displayName ?? null,
          abbreviation: comp.team?.abbreviation ?? null,
          logo: comp.team?.logo ?? null,
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
        if (!participant?.id) continue;

        const epPayload = {
          event_id: eventRow.id,
          participant_id: participant.id,
          score: comp.score ?? null,
          winner: comp.winner ?? false,
          home_away: comp.homeAway ?? null,
          record: comp.records?.map((r: any) => r.summary).join(" | ") ?? null,
          seed: comp.seed ?? null,
          position: comp.order ?? null,
          linescores: comp.linescores ?? null,
        };

        const epResp = await supabase
          .from("event_participants")
          .upsert(epPayload, { onConflict: ["event_id", "participant_id"] });

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