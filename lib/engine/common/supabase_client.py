import os
import sys
from pathlib import Path
from supabase import create_client
from dotenv import load_dotenv

# Get the directory containing this file
current_dir = Path(__file__).parent

# Look for .env in the parent directory (engine folder)
env_path = current_dir.parent / '.env'

# If not found, look in the current directory
if not env_path.exists():
    env_path = current_dir / '.env'

# Load the environment variables
load_dotenv(env_path)

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError(
        f"Missing Supabase environment variables. "
        f"Looked for .env in: {env_path}"
    )

# Initialize Supabase client
try:
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    # Test the connection
    supabase.table('news_cache').select("*").limit(1).execute()
except Exception as e:
    raise RuntimeError(f"Failed to initialize Supabase client: {e}")
