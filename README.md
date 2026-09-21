# Movie Ratings SQL Analysis

**SQLite · Python · joins · aggregation · reproducible analytics**

A movie-rating analysis workflow that transforms raw movie and rating records into tables answering questions about popularity, reviewer activity, average ratings, and historical review patterns.

## Technical design

`analysis.sql` contains the recovered SQL: base-table definitions, joins, grouped counts and averages, Unix timestamp conversion, filtered derived tables, and insertion into a working movie-table copy. `run.py` is a new standard-library Python launcher that replaces the original manual CSV import step and runs the analysis in an isolated in-memory SQLite database.

## Run

```bash
python run.py
```

Requires Python 3. The script reads `data/movies.csv` and `data/ratings.csv`, imports them after creating the base tables, then runs the remaining recovered statements. It prints table counts and ten most-reviewed titles. It does not overwrite an existing database.

## Product perspective

The project turns business questions into explicit query definitions. “Popular” means review count; “highest rated” uses an average; time-based segments depend on timestamp conversion and boundary choices. Those choices matter when interpreting an analytics feature.

## Validation

The launcher completed successfully with the recovered datasets: 10,329 movies and 105,339 ratings. All nine analysis tables were created. The most-reviewed titles included Pulp Fiction (325 reviews) and Forrest Gump (311 reviews). This validates the recovered end-to-end workflow; no original course autograder was run.

## Limitations

The SQL uses inner joins, so movies without ratings are absent from rating aggregates. Ordering of tied counts is unspecified. The insertion assumes a nonempty movies table. There are no production indexes, ingestion validation, or serving API. This is an educational analysis, not a recommendation engine.
