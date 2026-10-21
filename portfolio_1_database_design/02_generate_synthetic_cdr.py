"""Generate synthetic CDR coursework data. No real subscriber information is used."""
import csv
import random
from datetime import datetime, timedelta, timezone
from pathlib import Path

R = random.Random(8103)
ROOT = Path(__file__).resolve().parent
HEADERS = ['event_id','originating_number','receiving_number','call_started_at','duration_seconds','originating_cell_site_id','receiving_cell_site_id']
NUMBERS = [f'999{i:012d}' for i in range(1, 401)]  # invented 15-digit identifiers, not assigned subscriber numbers
SITES = [f'SYN_SITE_{i:03d}' for i in range(1, 26)]

with (ROOT / 'telephone_numbers.csv').open('w', newline='', encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(['phone_number']); w.writerows([[x] for x in NUMBERS])
with (ROOT / 'cell_sites.csv').open('w', newline='', encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(['cell_site_id','site_label','latitude','longitude'])
    for i, s in enumerate(SITES, 1):
        w.writerow([s, f'Fictional Site {i}', '', ''])  # no real-world coordinates

rows=[]
start=datetime(2026,1,1,tzinfo=timezone.utc)
for i in range(1,9501):
    # Hubs and communities create meaningful, wholly synthetic link-analysis patterns.
    if R.random() < 0.35:
        a=R.choice(NUMBERS[:12]); b=R.choice(NUMBERS)
    else:
        group=R.randrange(10)
        a=R.choice(NUMBERS[group*40:(group+1)*40]); b=R.choice(NUMBERS[group*40:(group+1)*40])
    if a==b: b=NUMBERS[(NUMBERS.index(a)+1)%len(NUMBERS)]
    when=start+timedelta(seconds=R.randrange(90*24*3600))
    rows.append([f'SYNCDR{i:06d}',a,b,when.isoformat(),R.randrange(0,1801),R.choice(SITES),R.choice(SITES)])

bad=[]
for j in range(500):
    k=j%5
    row=list(rows[j]); row[0]=f'SYNBAD{j+1:06d}'
    if k==0: row[1]='BAD_NUMBER'
    elif k==1: row[3]='not-a-timestamp'
    elif k==2: row[4]='-15'
    elif k==3: row[0]=rows[j][0]  # duplicate event ID
    else: row[5]='UNKNOWN_SITE'
    bad.append(row)
allrows=rows+bad
R.shuffle(allrows)
with (ROOT / 'synthetic_cdr_10000.csv').open('w', newline='', encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(HEADERS); w.writerows(allrows)
print('Generated 10,000 fictional CDR rows: 9,500 valid and 500 intentionally invalid.')
