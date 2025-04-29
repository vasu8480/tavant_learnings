
1. Fetching Indices
Retrieve the indices sorted by their store size using the following commands:
- Using CURL:
    ```bash
    curl -X GET "http://localhost:9200/_cat/indices?v&s=store.size:desc"
    ```
- Using Elastic's DSL:
    ```json
    GET /_cat/indices?v&s=store.size:desc
    ```
---
2. Deleting Indices
Delete specific indices with these commands:
- Using CURL:
    ```bash
    curl -X DELETE "http://localhost:9200/.ds-logs-generic-default-2025.03.10-*"
    ```
- Elastic's DSL:
    ```json
    DELETE /.ds-logs-generic-default-2025.03.10-000006
    DELETE /.ds-logs-generic-default-2025.02.11-000003
    ```
