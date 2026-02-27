
import os
from supabase import create_client, Client
from dotenv import load_dotenv

def test_supabase_connection():
    # Load environment variables from .env
    load_dotenv()
    
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_ANON_KEY")
    
    if not url or not key:
        print("❌ Error: SUPABASE_URL or SUPABASE_ANON_KEY not found in .env")
        return

    print(f"Connecting to: {url}")
    
    try:
        supabase: Client = create_client(url, key)
        
        # 1. Test 'sports' table
        print("\n--- Testing 'sports' table ---")
        sports = supabase.table("sports").select("*").execute()
        print(f"Count: {len(sports.data)}")
        for s in sports.data:
            print(f"- {s['name']} ({s['slug']})")
            
        # 2. Test 'events' table
        print("\n--- Testing 'events' table ---")
        events = supabase.table("events").select("id, name, start_time, status_state").limit(5).execute()
        print(f"Sample Events (count: {len(events.data)}):")
        for e in events.data:
            print(f"- {e['name']} | Status: {e['status_state']} | Start: {e['start_time']}")

        # 3. Test 'event_participants' table
        print("\n--- Testing 'event_participants' table ---")
        parts = supabase.table("event_participants").select("event_id, score, home_away, participants(name)").limit(5).execute()
        for p in parts.data:
            team_name = p['participants']['name'] if p['participants'] else 'Unknown'
            print(f"- Team: {team_name} | Score: {p['score']} | Side: {p['home_away']}")

        if len(events.data) == 0:
            print("\n⚠️ Warning: Database connection works, but no events found. Ingestion might be needed.")
        else:
            print("\n✅ Success: Data is flowing from Supabase!")

    except Exception as e:
        print(f"❌ Connection failed: {e}")

if __name__ == "__main__":
    test_supabase_connection()
