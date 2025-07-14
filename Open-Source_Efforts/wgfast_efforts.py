"""Create a .html file from the .json file."""

import pandas as pd
import json
import html
from datetime import date
from pathlib import Path
from pretty_html_table import build_table

efforts_file = Path('Open-Source_Efforts')/'WGFAST_open-source_efforts.json'
html_file = Path('Open-Source_Efforts')/'wgfast_efforts.html'

with open(efforts_file, 'r') as file:
    efforts = json.load(file)

df = pd.DataFrame(data=efforts['efforts'])
df.rename(columns={'title': 'Title', 'programming_language': 'Language',
                   'description': 'Description', 'url': 'URL'}, inplace=True)

df['Contact name'] = df.apply(lambda c: c['contact']['name'], axis=1)
df['Contact e-mail'] = df.apply(lambda c: c['contact']['e-mail'], axis=1)

df.drop(['contact'], axis=1, inplace=True)

# convert URL into proper HTML url's and emails into clickable linke
df['URL'] = df.apply(lambda c: f'<a href="{c['URL']}">{c['URL']}</a>', axis=1)
df['Contact email'] = df.apply(lambda e: f'<a href="mailto:{e['Contact e-mail']}">'
                               f'{e['Contact e-mail']}</a>', axis=1)

with open(html_file, 'w') as f:
    f.write('<h1>' + efforts['title'] + '</h1>')
    f.write('<p>Updated on ' + date.today().strftime('%d %b %Y') + '</p>')
    f.write('<p>' + efforts['description'] + '</p>')
    f.write(html.unescape(build_table(df, 'blue_light', padding='10px')))
