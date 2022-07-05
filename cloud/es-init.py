#!/usr/bin/env python
import requests

activities_index = """
{
    "mappings": {
        "properties": {
            "title": {"type": "text"},
            "weekly": {"type": "keyword"}
        }
    }
}
"""

headers = {
    'Content-Type': 'application/json',
}


def create_index(index_name):
    r = requests.put('http://localhost:9200/' + index_name, data=activities_index, headers=headers)
    if r.status_code == 200:
        print("created index " + index_name)
    else:
        print("create index " + index_name + " error:\n", r.json())


create_index("fomo-activities")
create_index("fomo-activities-submitted")
