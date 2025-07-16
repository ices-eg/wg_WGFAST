"""Create a .html file from the .json file."""
import json
import html
from datetime import date
from pathlib import Path
import pandas as pd
import itables

data_dir = Path('Open-Source_Efforts')
efforts_file = data_dir/'WGFAST_open-source_efforts.json'
html_file = data_dir/'wgfast_efforts.html'

with open(efforts_file, 'r', encoding='utf-8') as file:
    efforts = json.load(file)

df = pd.json_normalize(data=efforts['efforts']).drop(['contact.institution'], axis=1)
df.rename(columns={'title': 'Title', 'programming_language': 'Language',
                   'description': 'Description', 'url': 'URL', 'contact.name': 'Contact name',
                   'contact.e-mail': 'Contact e-mail'}, inplace=True)
df = df[df.Title != '']

# Make URLs proper, safe, and clickable
df['URL'] = df.apply(lambda c: '<a href="{0}">{0}</a>'
                     .format(html.escape(c['URL'], quote=True)), axis=1)
df['Contact email'] = df.apply(lambda e: '<a href="mailto:{0}">{0}</a>'
                               .format(html.escape(e['Contact e-mail'], quote=True)), axis=1)

table = itables.to_html_datatable(df, allow_html=True, paging=True, showIndex=False,
                                  footer=True, classes="display",
                                  style="width:100%")

with open(data_dir/'wgfast_efforts.html', 'w', encoding='utf-8') as f:
    f.write('<h1>' + html.escape(efforts['title']) + '</h1>')
    f.write('<p><small>Updated on ' + date.today().strftime('%d %b %Y') + '</small></p>')
    f.write('<p>' + html.escape(efforts['description']) + '</p>')
    f.write(table)
