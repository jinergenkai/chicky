#!/usr/bin/env python3
"""Tag words into domains using keyword matching. Outputs domain_words_seed.sql."""
from __future__ import annotations
import re
from pathlib import Path

DATA = Path(__file__).parent.parent / 'data'

DOMAIN_KEYWORDS = {
    'Food & Drink':   ['eat','food','drink','meal','cook','taste','hungry','fruit','vegetable',
                       'bread','meat','fish','rice','soup','salad','sugar','salt','milk','coffee',
                       'tea','wine','beer','juice','water','lunch','dinner','breakfast','snack',
                       'restaurant','kitchen','recipe','flavor','delicious','fresh','organic'],
    'Cooking':        ['cook','bake','fry','boil','grill','roast','steam','chop','slice','mix',
                       'stir','blend','season','marinate','simmer','preheat','oven','pan','pot',
                       'knife','ingredient','recipe','temperature','heat','oil','butter','flour'],
    'Finance':        ['money','bank','pay','cost','price','loan','debt','credit','invest','save',
                       'earn','spend','budget','income','profit','loss','tax','fee','fund','stock',
                       'bond','interest','rate','financial','economy','market','trade','cash',
                       'salary','wage','rent','mortgage','insurance','account','capital','asset'],
    'Technology':     ['computer','software','internet','data','digital','code','program','system',
                       'network','server','cloud','app','device','mobile','screen','keyboard',
                       'processor','memory','storage','battery','wireless','bluetooth','platform',
                       'algorithm','database','security','encrypt','download','upload','stream'],
    'Business':       ['business','company','market','product','service','customer','sale','brand',
                       'strategy','management','team','project','goal','performance','revenue',
                       'growth','partner','contract','negotiate','meeting','presentation','report',
                       'client','employee','staff','office','professional','corporate','industry'],
    'Travel':         ['travel','trip','journey','tour','flight','hotel','airport','ticket','visa',
                       'passport','luggage','destination','map','guide','tourist','vacation','holiday',
                       'beach','mountain','city','country','culture','adventure','explore','pack'],
    'Health':         ['health','body','medicine','doctor','hospital','pain','sick','disease',
                       'treatment','exercise','diet','sleep','mental','stress','symptom','drug',
                       'vitamin','immune','blood','heart','lung','brain','muscle','bone','skin'],
    'Education':      ['learn','study','school','university','student','teacher','lesson','class',
                       'exam','test','grade','knowledge','skill','read','write','understand',
                       'research','theory','practice','training','degree','certificate','course'],
    'Sports':         ['sport','game','play','win','team','player','score','match','competition',
                       'fitness','run','swim','jump','throw','kick','ball','court','field','race',
                       'champion','athlete','coach','training','exercise','strength','speed'],
    'Arts':           ['art','music','film','book','story','design','create','draw','paint','write',
                       'sing','dance','perform','theater','gallery','museum','culture','literature',
                       'poetry','novel','character','plot','style','color','image','photography'],
    'Science':        ['science','research','experiment','theory','evidence','discover','nature',
                       'biology','chemistry','physics','mathematics','energy','force','gravity',
                       'evolution','cell','molecule','atom','element','reaction','observation'],
    'Daily Life':     ['home','family','friend','work','time','day','morning','night','week',
                       'month','year','talk','walk','drive','shop','clean','help','meet','call',
                       'need','want','think','feel','make','take','give','get','come','go'],
    'Environment':    ['environment','nature','climate','energy','green','carbon','pollution',
                       'recycle','sustainable','forest','ocean','animal','plant','ecosystem',
                       'temperature','weather','rain','sun','wind','earth','resource','waste'],
}

print("Loading words...")
words_file = DATA / 'words_seed.sql'
words = []
for line in words_file.read_text(encoding='utf-8').splitlines():
    m = re.match(r"INSERT INTO words \(word,.*?\) VALUES \('([^']+)'", line)
    if m:
        words.append(m.group(1))
print(f"  {len(words)} words loaded")

word_domains: dict[str, list[str]] = {}
for word in words:
    matched = []
    for domain, keywords in DOMAIN_KEYWORDS.items():
        if any(kw in word.lower() or word.lower() in kw for kw in keywords):
            matched.append(domain)
    if matched:
        word_domains[word] = matched

print(f"  Tagged {len(word_domains)} words across {len(DOMAIN_KEYWORDS)} domains")

out = DATA / 'domain_words_seed.sql'
with open(out, 'w', encoding='utf-8') as f:
    f.write("-- Domain-word associations (rule-based tagging)\n")
    f.write("-- Run AFTER all_migrations.sql and words_seed.sql\n\n")
    for word, domains in word_domains.items():
        word_esc = word.replace("'", "''")
        for domain in domains:
            domain_esc = domain.replace("'", "''")
            f.write(
                f"INSERT INTO domain_words (domain_id, word_id)\n"
                f"SELECT d.id, w.id FROM domains d, words w\n"
                f"WHERE d.name = '{domain_esc}' AND w.word = '{word_esc}'\n"
                f"ON CONFLICT DO NOTHING;\n"
            )

print(f"Written: {out}")
