"""Import generated CSV into the five-table PostgreSQL schema. Requires psycopg 3."""
import csv
import os
import re
from datetime import datetime
from pathlib import Path

try:
    import psycopg
    from psycopg.types.json import Jsonb
except ImportError as e:
    raise SystemExit('Install dependency first: py -m pip install "psycopg[binary]"') from e

ROOT = Path(__file__).resolve().parent
CSV_FILE = ROOT / 'synthetic_cdr_10000.csv'
PHONE_RE = re.compile(r'^\d{10,15}$')
REQUIRED = ['event_id','originating_number','receiving_number','call_started_at','duration_seconds','originating_cell_site_id','receiving_cell_site_id']

# Supply password via environment variable, never save it in source control.
password = os.environ.get('PGPASSWORD')
if not password:
    raise SystemExit('Set PGPASSWORD in your terminal before running. Do not put passwords in GitHub.')

with psycopg.connect(host='localhost', port=5432, dbname='cdr_analysis_db', user='postgres', password=password) as conn:
    with conn.cursor() as cur:
        for file in ('telephone_numbers.csv','cell_sites.csv','synthetic_cdr_10000.csv'):
            if not (ROOT/file).exists():
                raise SystemExit(f'Missing {file}. Run 02_generate_synthetic_cdr.py first.')
        with (ROOT/'telephone_numbers.csv').open(newline='',encoding='utf-8') as f:
            for row in csv.DictReader(f):
                cur.execute('INSERT INTO telephone_numbers(phone_number) VALUES (%s) ON CONFLICT DO NOTHING', (row['phone_number'],))
        with (ROOT/'cell_sites.csv').open(newline='',encoding='utf-8') as f:
            for row in csv.DictReader(f):
                cur.execute('INSERT INTO cell_sites(cell_site_id,site_label) VALUES (%s,%s) ON CONFLICT DO NOTHING', (row['cell_site_id'],row['site_label']))
        cur.execute('SELECT phone_number FROM telephone_numbers')
        phones={r[0] for r in cur.fetchall()}
        cur.execute('SELECT cell_site_id FROM cell_sites')
        sites={r[0] for r in cur.fetchall()}
        cur.execute("INSERT INTO import_batches(filename,total_rows,status) VALUES (%s,0,'PENDING') RETURNING batch_id", (CSV_FILE.name,))
        batch_id=cur.fetchone()[0]
        accepted=rejected=0
        seen=set()
        with CSV_FILE.open(newline='',encoding='utf-8') as f:
            reader=csv.DictReader(f)
            if reader.fieldnames != REQUIRED:
                raise ValueError(f'Unexpected CSV columns: {reader.fieldnames}')
            for line_num, row in enumerate(reader, start=2):
                reasons=[]
                eid=row['event_id'].strip()
                if not eid or len(eid)>40: reasons.append('missing or oversized event ID')
                if eid in seen: reasons.append('duplicate event ID in CSV')
                seen.add(eid)
                a=row['originating_number'].strip(); b=row['receiving_number'].strip()
                if not PHONE_RE.fullmatch(a) or a not in phones: reasons.append('invalid or unknown originating number')
                if not PHONE_RE.fullmatch(b) or b not in phones: reasons.append('invalid or unknown receiving number')
                try:
                    dt=datetime.fromisoformat(row['call_started_at'])
                    if dt.tzinfo is None: raise ValueError('timezone required')
                except ValueError:
                    reasons.append('invalid timestamp or missing timezone'); dt=None
                try:
                    duration=int(row['duration_seconds'])
                    if duration<0: raise ValueError()
                except ValueError:
                    reasons.append('invalid or negative duration'); duration=None
                for col in ('originating_cell_site_id','receiving_cell_site_id'):
                    if row[col] and row[col] not in sites: reasons.append('unknown '+col)
                if not reasons:
                    cur.execute('''INSERT INTO call_events(event_id,batch_id,originating_number,receiving_number,call_started_at,duration_seconds,originating_cell_site_id,receiving_cell_site_id)
                        VALUES (%s,%s,%s,%s,%s,%s,%s,%s) ON CONFLICT (event_id) DO NOTHING''',
                        (eid,batch_id,a,b,dt,duration,row['originating_cell_site_id'] or None,row['receiving_cell_site_id'] or None))
                    if cur.rowcount==0: reasons.append('event ID already exists in database')
                if reasons:
                    cur.execute('''INSERT INTO import_rejections(batch_id,source_row_number,raw_record,rejection_reason)
                        VALUES (%s,%s,%s,%s)''', (batch_id,line_num,Jsonb(row),'; '.join(reasons)))
                    rejected+=1
                else: accepted+=1
        cur.execute('''UPDATE import_batches SET total_rows=%s,accepted_rows=%s,rejected_rows=%s,status='COMPLETED'
            WHERE batch_id=%s''',(accepted+rejected,accepted,rejected,batch_id))
    conn.commit()
print(f'Batch {batch_id}: accepted={accepted}, rejected={rejected}, total={accepted+rejected}')
print('Expected on a fresh database: accepted=9500, rejected=500.')
