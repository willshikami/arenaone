import os
from supabase import create_client, Client
from dotenv import load_dotenv
import json

def check_f1_games():
    load_dotenv()
    
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_ANON_KEY")
    
    if not url or not key:
        print("Error: SUPABASE_URL or SUPABASE_ANON_KEY not found in .env")
        return

    try:
        supabase: Client = create_client(url, key)
        
        # We need to query events where sports.slug is 'f1'
        # based on SupabaseService: .eq('sports.slug', slug)
        # and it selects events table.
        
        print("--- Querying F1 Games ---")
        response = supabase.table("events").select("id, name, start_time, status_type, status_state, completed, is_live, sports!inner(slug)").eq("sports.slug", "f1").execute()
        
        games = response.data
        print(f"Total F1 games found: {len(games)}")
        
        if len(games) > 0:
            for g in games:
                print(f"Game: {g['name']}")
                print(f"  ID: {g['id']}")
                print(f"  Start Time: {g['start_time']}")
                print(f"  Status Type: {g['status_type']}")
                print(f"  Status State: {g['status_state']}")
                print(f"  Completed: {g['completed']}")
                print(f"  Is Live: {g['is_live']}")
                print("-" * 20)
        else:
            print("No F1 games found in 'events' table with slug 'f1'.")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    check_f1_games()
