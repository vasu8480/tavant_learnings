df -h /elk

du -h /elk/nodes --max-depth=2 | sort -hr | head -10

df -h /elk

curl -X GET "localhost:9200/_cat/indices?v&s=store.size:desc"


curl -X DELETE "localhost:9200/applogs-2025.05.14"

df -h /elk
