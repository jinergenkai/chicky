"""Run all SQL migrations against the Supabase PostgreSQL database."""
import asyncio
import os
import glob
import ssl
import asyncpg
from dotenv import load_dotenv

load_dotenv('../chicky_api/.env')

DATABASE_URL = os.getenv('DATABASE_URL')

async def run_migrations():
    print(f"Connecting to database...")
    ssl_ctx = ssl.create_default_context()
    ssl_ctx.check_hostname = False
    ssl_ctx.verify_mode = ssl.CERT_NONE
    
    conn = await asyncpg.connect(DATABASE_URL, ssl=ssl_ctx)
    print("Connected!\n")
    
    migration_files = sorted(glob.glob('migrations/*.sql'))
    print(f"Found {len(migration_files)} migration files\n")
    
    for filepath in migration_files:
        filename = os.path.basename(filepath)
        with open(filepath, 'r', encoding='utf-8') as f:
            sql = f.read()
        try:
            await conn.execute(sql)
            print(f"  OK  {filename}")
        except Exception as e:
            # Skip "already exists" errors
            if 'already exists' in str(e):
                print(f"  --  {filename} (already exists, skipped)")
            else:
                print(f"  ERR {filename}: {e}")
    
    if os.path.exists('seed.sql'):
        with open('seed.sql', 'r', encoding='utf-8') as f:
            sql = f.read()
        try:
            await conn.execute(sql)
            print(f"  OK  seed.sql")
        except Exception as e:
            if 'already exists' in str(e) or 'duplicate' in str(e).lower():
                print(f"  --  seed.sql (already seeded)")
            else:
                print(f"  ERR seed.sql: {e}")
    
    await conn.close()
    print("\nDone.")

asyncio.run(run_migrations())
