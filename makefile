meilisearch:
	docker run --rm \
  	--name meilisearch \
  	-p 7700:7700 \
  	-e MEILI_MASTER_KEY="foo" \
	-e MEILI_EXPERIMENTAL_ENABLE_VECTOR=true \
 	-v meili_data:/meili_data \
  	getmeili/meilisearch:latest


curl \
  -X PATCH 'http://localhost:7700/experimental-features/' \
  -H 'Content-Type: application/json'  \
  -H 'Authorization: Bearer foo' \
  --data-binary '{
    "vectorStore": true
  }'


curl \
  -X PATCH 'http://localhost:7700/indexes/movies/settings' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer foo' \
  --data-binary '{
    "embedders": {
      "default": {
        "source": "huggingFace",
        "model": "BAAI/bge-m3",
        "documentTemplate": "A movie titled {{doc.title}} whose description starts with {{doc.overview|truncatewords: 20}}"
      }
    }
  }'


curl -X POST 'localhost:7700/indexes/movies/search' \
  -H 'content-type: application/json' \
  -H 'Authorization: Bearer foo' \
  --data-binary '{
    "q": "kitchen utensils",
    "hybrid": {
      "semanticRatio": 0.9,
      "embedder": "default"
    }
  }'


curl \
  -X PATCH 'http://localhost:7700/indexes/movies/settings' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer foo' \
  --data-binary '{
    "embedders": {
      "default": {
        "source": "huggingFace",
        "model": "BAAI/bge-base-en-v1.5",
        "documentTemplate": "A movie titled {{doc.title}} whose description starts with {{doc.overview|truncatewords: 20}}"
      }
    }
  }'


curl \
  -X PATCH 'http://localhost:7700/experimental-features/' \
  -H 'Content-Type: application/json'  \
  -H 'Authorization: Bearer foo' \
  --data-binary '{ "vectorStore": true }'
