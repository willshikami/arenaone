# Supabase Setup

This document records the database schema and edge functions used to power the ArenaOne backend.

## Database Schema (SQL)

Run the following SQL in your Supabase SQL Editor to create the necessary tables and seed the sports data.

```sql
-- Status of an event
create type event_status as enum ('scheduled', 'in_progress', 'completed', 'postponed', 'canceled');

-- Season type
create type season_type as enum ('preseason', 'regular', 'postseason');

-- Tennis surfaces (used by many APIs)
create type tennis_surface as enum ('clay', 'grass', 'hard', 'carpet', 'unknown');

-- Golf round type
create type golf_round_type as enum ('stroke_play', 'match_play', 'scramble', 'unknown');


-- Sports (e.g. basketball, football, tennis)
CREATE TABLE sports (
    id BIGINT PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    abbreviation TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sports_slug ON sports(slug);


-- Leagues (e.g. NBA, Premier League, ATP/WTA)
CREATE TABLE leagues (
    id BIGINT PRIMARY KEY,
    sport_id BIGINT REFERENCES sports(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    abbreviation TEXT,
    season_year INT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_leagues_sport_id ON leagues(sport_id);
CREATE INDEX idx_leagues_season_year ON leagues(season_year);


  -- Events (Matches / Games / Races / Rounds)
CREATE TABLE events (
    id BIGINT PRIMARY KEY,
    league_id BIGINT REFERENCES leagues(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    short_name TEXT,
    event_date TIMESTAMP,
    end_date TIMESTAMP,
    venue TEXT,
    status JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_events_league_id ON events(league_id);
CREATE INDEX idx_events_event_date ON events(event_date);
  

  -- Competitions (specific matchups within an event, e.g. Federer vs Nadal in Wimbledon Final)
CREATE TABLE competitions (
    id BIGINT PRIMARY KEY,
    event_id BIGINT REFERENCES events(id) ON DELETE CASCADE,
    type_id INT,
    neutral_site BOOLEAN,
    play_by_play_available BOOLEAN,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_competitions_event_id ON competitions(event_id);



-- Teams (e.g. Lakers, Manchester United, Federer)
CREATE TABLE teams (
    id BIGINT PRIMARY KEY,
    name TEXT NOT NULL,
    abbreviation TEXT,
    display_name TEXT,
    short_display_name TEXT,
    color TEXT,
    alternate_color TEXT,
    is_active BOOLEAN,
    logo TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_teams_name ON teams(name);


-- Competition_Teams (linking teams/athletes to specific competitions with stats)
CREATE TABLE competition_teams (
    id BIGINT PRIMARY KEY,
    competition_id BIGINT REFERENCES competitions(id) ON DELETE CASCADE,
    team_id BIGINT REFERENCES teams(id) ON DELETE CASCADE,
    home_away TEXT,
    score TEXT,
    statistics JSONB,
    records JSONB,
    order_in_competition INT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_competition_teams_competition_id ON competition_teams(competition_id);



-- Broadcasts (TV/streaming info for events)
CREATE TABLE broadcasts (
    id BIGINT PRIMARY KEY,
    competition_id BIGINT REFERENCES competitions(id) ON DELETE CASCADE,
    market TEXT,
    names TEXT[],
    media JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);



-- Highlights (links to videos or recaps of key moments)
CREATE TABLE highlights (
    id BIGINT PRIMARY KEY,
    event_id BIGINT REFERENCES events(id) ON DELETE CASCADE,
    type TEXT,
    url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

```



```
## Edge Function: ingest-events (TypeScript)
// supabase/functions/ingestSportsData/index.ts

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "npm:@supabase/supabase-js@2.31.0";

type Json = Record<string, any>;

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const SPORT_CONFIG: Record<string, { id: string; name: string; slug: string; abbreviation: string }> = {
  tennis: { id: "1", name: "Tennis", slug: "tennis", abbreviation: "TEN" },
  golf: { id: "2", name: "Golf", slug: "golf", abbreviation: "GLF" },
  racing: { id: "3", name: "Racing", slug: "racing", abbreviation: "RAC" },
  soccer: { id: "4", name: "Soccer", slug: "soccer", abbreviation: "SOC" },
  basketball: { id: "5", name: "Basketball", slug: "basketball", abbreviation: "BKB" },
};

const API_ENDPOINTS: Record<string, string[]> = {
  tennis: [
    "https://site.api.espn.com/apis/site/v2/sports/tennis/atp/scoreboard",
    "https://sports.core.api.espn.com/v2/sports/tennis/leagues/atp/events/411-2026?lang=en&region=us",
  ],
  golf: [
    "https://site.api.espn.com/apis/site/v2/sports/golf/pga/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/lpga/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/liv/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/eur/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/tgl/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/champions-tour/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/mens-olympics-golf/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/ntw/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/golf/womens-olympics-golf/scoreboard",
  ],
  racing: [
    "https://site.api.espn.com/apis/site/v2/sports/racing/f1/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/racing/irl/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-premier/scoreboard",
  ],
  soccer: [
    "https://site.api.espn.com/apis/site/v2/sports/soccer/eng.1/scoreboard",
    "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard",
  ],
  basketball: [
    "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard",
  ],
};

function asArray<T = any>(value: any): T[] {
  return Array.isArray(value) ? value : [];
}

function cleanUrl(url: string): string {
  return url.replace(/^http:\/\//i, "https://");
}

function inferLeagueSlugFromUrl(url: string): string | null {
  const cleaned = cleanUrl(url);

  const m = cleaned.match(/\/leagues\/([^/?]+)/i);
  if (m?.[1]) return decodeURIComponent(m[1]);

  const m2 = cleaned.match(/\/sports\/[^/]+\/([^/]+)\/scoreboard/i);
  if (m2?.[1]) return decodeURIComponent(m2[1]);

  return null;
}

function safeTimestamp(value: any): string | null {
  if (!value || typeof value !== "string") return null;
  return value;
}

function pickVenue(event: Json): string | null {
  if (typeof event?.venue?.displayName === "string") return event.venue.displayName;
  if (typeof event?.venue?.fullName === "string") return event.venue.fullName;

  const firstCompetition = asArray(event?.competitions)[0];
  if (typeof firstCompetition?.venue?.fullName === "string") return firstCompetition.venue.fullName;
  if (typeof firstCompetition?.venue?.address?.summary === "string") return firstCompetition.venue.address.summary;
  if (typeof firstCompetition?.court?.description === "string") return firstCompetition.court.description;

  return null;
}

function pickEventStatus(event: Json): Json | null {
  if (event?.status && typeof event.status === "object") return event.status;

  const firstCompetition = asArray(event?.competitions)[0];
  if (firstCompetition?.status && typeof firstCompetition.status === "object") {
    return firstCompetition.status;
  }

  return null;
}

function toStableBigintString(input: string): string {
  const FNV_OFFSET = 14695981039346656037n;
  const FNV_PRIME = 1099511628211n;
  const MAX_SIGNED_BIGINT = 9223372036854775807n;

  let hash = FNV_OFFSET;
  for (let i = 0; i < input.length; i++) {
    hash ^= BigInt(input.charCodeAt(i));
    hash = (hash * FNV_PRIME) % MAX_SIGNED_BIGINT;
  }

  if (hash < 0n) hash = -hash;
  if (hash === 0n) hash = 1n;
  return hash.toString();
}

function normalizeBigintId(raw: any, fallbackKey: string): string {
  if (typeof raw === "number" && Number.isFinite(raw)) {
    return Math.trunc(raw).toString();
  }

  if (typeof raw === "string") {
    const trimmed = raw.trim();
    if (/^\d+$/.test(trimmed)) return trimmed;
    return toStableBigintString(`${fallbackKey}:${trimmed}`);
  }

  return toStableBigintString(`${fallbackKey}:unknown`);
}

function competitionIdFrom(eventId: string, comp: Json, index: number): string {
  if (comp?.id != null) {
    return normalizeBigintId(comp.id, `competition:${eventId}:${index}`);
  }
  return toStableBigintString(`competition:${eventId}:${index}`);
}

function competitionTeamIdFrom(
  competitionId: string,
  entityId: string,
  order: number | null,
  homeAway: string | null,
): string {
  return toStableBigintString(
    `competition_team:${competitionId}:${entityId}:${order ?? "na"}:${homeAway ?? "na"}`,
  );
}

function highlightIdFrom(eventId: string, h: Json, index: number): string {
  const seed =
    h?.id ??
    h?.url ??
    h?.href ??
    h?.links?.[0]?.href ??
    h?.title ??
    h?.headline ??
    h?.type ??
    index;

  return normalizeBigintId(seed, `highlight:${eventId}:${index}`);
}

async function fetchJson(url: string): Promise<Json> {
  const finalUrl = cleanUrl(url);
  const response = await fetch(finalUrl, {
    headers: {
      Accept: "application/json",
      "User-Agent": "supabase-edge-function/ingestSportsData",
    },
  });

  if (!response.ok) {
    const body = await response.text().catch(() => "");
    throw new Error(`Fetch failed ${response.status} for ${finalUrl}: ${body.slice(0, 300)}`);
  }

  return await response.json();
}

async function upsertOne(table: string, row: Json) {
  const { error } = await supabase.from(table).upsert(row, { onConflict: "id" });
  if (error) {
    throw new Error(`Upsert failed for ${table}: ${error.message}`);
  }
}

async function upsertMany(table: string, rows: Json[], onConflict = "id") {
  if (!rows.length) return;

  const { error } = await supabase.from(table).upsert(rows, { onConflict });
  if (error) {
    throw new Error(`Upsert failed for ${table}: ${error.message}`);
  }
}

async function ensureSportRow(sportKey: string) {
  const sport = SPORT_CONFIG[sportKey];
  if (!sport) throw new Error(`Unknown sport key: ${sportKey}`);

  const { data: existing, error: selectError } = await supabase
    .from("sports")
    .select("id, slug")
    .eq("slug", sport.slug)
    .maybeSingle();

  if (selectError) {
    throw new Error(`Select failed for sports: ${selectError.message}`);
  }

  if (existing) {
    const { error: updateError } = await supabase
      .from("sports")
      .update({
        name: sport.name,
        abbreviation: sport.abbreviation,
      })
      .eq("slug", sport.slug);

    if (updateError) {
      throw new Error(`Update failed for sports: ${updateError.message}`);
    }

    return String(existing.id);
  }

  const { error: insertError } = await supabase.from("sports").insert({
    id: sport.id,
    name: sport.name,
    slug: sport.slug,
    abbreviation: sport.abbreviation,
  });

  if (insertError) {
    throw new Error(`Insert failed for sports: ${insertError.message}`);
  }

  return sport.id;
}

type ProcessContext = {
  sportKey: string;
  sportId: string;
  sourceUrl: string;
  leagueCache: Map<string, string>;
  report: {
    endpoints: string[];
    leagues: number;
    events: number;
    competitions: number;
    teams: number;
    highlights: number;
    errors: { url: string; error: string }[];
  };
};

async function processPayload(payload: Json, ctx: ProcessContext) {
  const inferredLeagueSlug = inferLeagueSlugFromUrl(ctx.sourceUrl);

  const topLevelLeagues = [
    ...asArray(payload?.leagues),
    ...(payload?.league ? [payload.league] : []),
  ];

  const leaguesToUpsert: Json[] = [];
  let defaultLeagueId: string | null = null;

  for (const league of topLevelLeagues) {
    const leagueId = normalizeBigintId(
      league?.id ?? league?.uid ?? `${ctx.sportKey}:${league?.slug ?? league?.name ?? "league"}`,
      `league:${ctx.sportKey}`,
    );

    const season = league?.season ?? {};
    const leagueSlug = String(league?.slug ?? inferredLeagueSlug ?? "").trim();

    leaguesToUpsert.push({
      id: leagueId,
      sport_id: ctx.sportId,
      name: ((league?.name ?? league?.shortName ?? leagueSlug) || `${ctx.sportKey} league`),
      abbreviation: league?.abbreviation ?? null,
      season_year: season?.year ?? payload?.season?.year ?? null,
      start_date: safeTimestamp(season?.startDate ?? league?.calendarStartDate),
      end_date: safeTimestamp(season?.endDate ?? league?.calendarEndDate),
      raw_data: league,
    });

    if (leagueSlug) ctx.leagueCache.set(leagueSlug, leagueId);
    if (!defaultLeagueId) defaultLeagueId = leagueId;
  }

  if (!defaultLeagueId && inferredLeagueSlug && ctx.leagueCache.has(inferredLeagueSlug)) {
    defaultLeagueId = ctx.leagueCache.get(inferredLeagueSlug)!;
  }

  if (leaguesToUpsert.length) {
    await upsertMany("leagues", leaguesToUpsert);
    ctx.report.leagues += leaguesToUpsert.length;
  }

  const payloadEvents = asArray(payload?.events);
  const singleEventPayload =
    payload?.id != null && payload?.name != null && Array.isArray(payload?.competitions)
      ? [payload]
      : [];

  const events = payloadEvents.length ? payloadEvents : singleEventPayload;

  for (const event of events) {
    const eventId = normalizeBigintId(
      event?.id ?? event?.uid ?? `${ctx.sourceUrl}:${event?.name ?? "event"}`,
      `event:${ctx.sportKey}`,
    );

    let leagueId: string | null = null;

    if (event?.league?.id != null) {
      leagueId = normalizeBigintId(event.league.id, `league_ref:${ctx.sportKey}`);
    } else if (event?.leagues?.[0]?.id != null) {
      leagueId = normalizeBigintId(event.leagues[0].id, `league_ref:${ctx.sportKey}`);
    } else {
      leagueId = defaultLeagueId;
    }

    const eventRow = {
      id: eventId,
      league_id: leagueId,
      name: event?.name ?? event?.shortName ?? `Event ${eventId}`,
      short_name: event?.shortName ?? null,
      event_date: safeTimestamp(event?.date),
      end_date: safeTimestamp(event?.endDate),
      venue: pickVenue(event),
      status: pickEventStatus(event),
      raw_data: event,
    };

    await upsertOne("events", eventRow);
    ctx.report.events += 1;

    const { error: deleteError } = await supabase
      .from("competitions")
      .delete()
      .eq("event_id", eventId);

    if (deleteError) {
      throw new Error(`Delete competitions failed for event ${eventId}: ${deleteError.message}`);
    }

    const competitions = asArray(event?.competitions);
    const teamRowsMap = new Map<string, Json>();
    const competitionRows: Json[] = [];
    const competitionTeamRows: Json[] = [];
    const highlightRows: Json[] = [];

    for (let i = 0; i < competitions.length; i++) {
      const comp = competitions[i];
      const competitionId = competitionIdFrom(eventId, comp, i);

      competitionRows.push({
        id: competitionId,
        event_id: eventId,
        type_id:
          comp?.type?.id != null && !Number.isNaN(Number(comp.type.id))
            ? Number(comp.type.id)
            : null,
        neutral_site: comp?.neutralSite ?? null,
        play_by_play_available: comp?.playByPlayAvailable ?? event?.playByPlayAvailable ?? null,
        raw_data: comp,
      });

      const competitors = asArray(comp?.competitors);

      for (let j = 0; j < competitors.length; j++) {
        const competitor = competitors[j];
        const baseEntity = competitor?.team ?? competitor?.athlete ?? competitor;

        const entityId = normalizeBigintId(
          competitor?.team?.id ??
            competitor?.athlete?.id ??
            competitor?.id ??
            `${competitionId}:${j}`,
          `team_entity:${ctx.sportKey}`,
        );

        const teamRow = {
          id: entityId,
          name:
            baseEntity?.name ??
            baseEntity?.fullName ??
            baseEntity?.displayName ??
            competitor?.name ??
            `Entity ${entityId}`,
          abbreviation: baseEntity?.abbreviation ?? null,
          display_name:
            baseEntity?.displayName ??
            baseEntity?.fullName ??
            baseEntity?.name ??
            competitor?.name ??
            null,
          short_display_name:
            baseEntity?.shortDisplayName ??
            baseEntity?.shortName ??
            null,
          color: baseEntity?.color ?? null,
          alternate_color: baseEntity?.alternateColor ?? null,
          is_active: baseEntity?.isActive ?? baseEntity?.active ?? null,
          logo:
            baseEntity?.logo ??
            baseEntity?.flag?.href ??
            baseEntity?.headshot ??
            null,
          raw_data: baseEntity,
        };

        teamRowsMap.set(entityId, teamRow);

        const competitionTeamId = competitionTeamIdFrom(
          competitionId,
          entityId,
          typeof competitor?.order === "number" ? competitor.order : j,
          competitor?.homeAway ?? null,
        );

        const score =
          competitor?.score?.displayValue ??
          competitor?.score ??
          null;

        competitionTeamRows.push({
          id: competitionTeamId,
          competition_id: competitionId,
          team_id: entityId,
          home_away: competitor?.homeAway ?? null,
          score: score != null ? String(score) : null,
          statistics: competitor?.statistics ?? null,
          records: competitor?.records ?? null,
          order_in_competition:
            typeof competitor?.order === "number" ? competitor.order : j,
        });
      }

      const compHighlights = asArray(comp?.highlights);
      for (let hIndex = 0; hIndex < compHighlights.length; hIndex++) {
        const h = compHighlights[hIndex];
        highlightRows.push({
          id: highlightIdFrom(eventId, h, hIndex),
          event_id: eventId,
          type: h?.type ?? h?.headline ?? h?.title ?? "highlight",
          url: h?.url ?? h?.href ?? h?.links?.[0]?.href ?? null,
        });
      }
    }

    const eventHighlights = asArray(event?.highlights);
    for (let hIndex = 0; hIndex < eventHighlights.length; hIndex++) {
      const h = eventHighlights[hIndex];
      highlightRows.push({
        id: highlightIdFrom(eventId, h, hIndex + 1000),
        event_id: eventId,
        type: h?.type ?? h?.headline ?? h?.title ?? "highlight",
        url: h?.url ?? h?.href ?? h?.links?.[0]?.href ?? null,
      });
    }

    if (teamRowsMap.size) {
      const rows = [...teamRowsMap.values()];
      await upsertMany("teams", rows);
      ctx.report.teams += rows.length;
    }

    if (competitionRows.length) {
      await upsertMany("competitions", competitionRows);
      ctx.report.competitions += competitionRows.length;
    }

    if (competitionTeamRows.length) {
      const dedupedCompetitionTeamRows = [
        ...new Map(competitionTeamRows.map((row) => [row.id, row])).values(),
      ];
      await upsertMany("competition_teams", dedupedCompetitionTeamRows);
    }

    if (highlightRows.length) {
      const dedupedHighlightRows = [
        ...new Map(highlightRows.map((row) => [row.id, row])).values(),
      ];
      await upsertMany("highlights", dedupedHighlightRows);
      ctx.report.highlights += dedupedHighlightRows.length;
    }
  }
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  if (req.method !== "POST" && req.method !== "GET") {
    return new Response(
      JSON.stringify({ success: false, error: "Method not allowed" }),
      {
        status: 405,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      },
    );
  }

  const report = {
    endpoints: [] as string[],
    leagues: 0,
    events: 0,
    competitions: 0,
    teams: 0,
    highlights: 0,
    errors: [] as { url: string; error: string }[],
  };

  try {
    const leagueCache = new Map<string, string>();

    for (const [sportKey, urls] of Object.entries(API_ENDPOINTS)) {
      const sportId = await ensureSportRow(sportKey);

      for (const url of urls) {
        report.endpoints.push(url);

        try {
          const payload = await fetchJson(url);

          await processPayload(payload, {
            sportKey,
            sportId,
            sourceUrl: url,
            leagueCache,
            report,
          });
        } catch (error) {
          const message = error instanceof Error ? error.message : String(error);
          console.error(`[${sportKey}] ${url}: ${message}`);
          report.errors.push({ url, error: message });
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: report.errors.length === 0,
        summary: {
          endpoints_processed: report.endpoints.length,
          leagues_upserted: report.leagues,
          events_upserted: report.events,
          competitions_upserted: report.competitions,
          teams_upserted: report.teams,
          highlights_upserted: report.highlights,
          errors: report.errors.length,
        },
        errors: report.errors,
      }),
      {
        status: report.errors.length === 0 ? 200 : 207,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      },
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`Unhandled ingest error: ${message}`);

    return new Response(
      JSON.stringify({
        success: false,
        error: message,
        summary: report,
      }),
      {
        status: 500,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      },
    );
  }
});

```


