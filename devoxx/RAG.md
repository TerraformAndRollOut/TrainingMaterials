@prpatel

RAG = Retrieval Augmented Generation = Exposing your own data to a LLM

## Semantic search
- Understands context and intent, where index or key search only does exact match
- Understands the relationship between words
- Uses previous search history for additional context
- Alot slower, and needs GPU acceleration (ALL of the vectors)


## Embedding and Attention
- Turns text into vectors
- Compares vectors in the database
- Embedding is a neural network that understands words, and the relationship between them.
- E.g Something like [200, 100, 350 ....] might be "Event"  and [210, 110, 320, ...] could be "Conference"
  - Similar values for similar words
  - Vectors are huge, hundreds of values in each vector
  - Vector will only match if you use the same algorithm for enbedding as queries
- "Attention" decides what is most important
- Large documents are cut into chunks, there are various chunking methodologies. By sentence, set size, with or without overlap etc.
- Vectors are searched to find which ones are the closest match
  - use Cosine or Eucldian distance calcs to rate the match 0-1. i.e. 0.1 bad match, 0.9 is a good match 


Flow is:

Read data > Chunk it > Vectorize the chunks > stick in the DB > Search using LLM, but with the injected data

Naive RAG
Contextual RAG