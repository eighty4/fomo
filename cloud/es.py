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

r = requests.put('http://localhost:9200/activities', data=activities_index, headers=headers)
print("create activities index: ", r.json())
