# Further From

The static site behind https://furtherfrom.com. Pick two moments and find the
crossover: the moment we'll be further from the later one than it was from the
earlier one.

There's no build step and no dependencies. `public/` is the whole site, and
pushing to `main` deploys it to GitHub Pages.

```
public/index.html    the page: comparison, picker, upcoming crossovers, interesting pairs
public/when.js       the date math, shared by the page and the tests
public/events.json   every event
test/                node --test checks for the date math and the events
scripts/serve        serves public/ locally
scripts/check-dates  compares event dates with Wikidata
scripts/check-claims finds Wikipedia sentences that back up a description
scripts/upcoming     prints the next crossovers
```

## Run it locally

```sh
scripts/serve        # http://localhost:8000/
scripts/serve 9000   # or pick a port
node --test test/*.test.mjs
```

Use the server rather than opening the file directly, since the page fetches `events.json`.

## Adding an event

Add an object to `public/events.json`. Order doesn't matter.

```json
{
  "key": "apollo-11-moon-landing",
  "date": "1969-07-20",
  "title": "Apollo 11 Moon Landing",
  "phrase": "the Apollo 11 Moon landing",
  "category": "space",
  "description": "Apollo 11 (July 16–24, 1969) was the American spaceflight that first landed humans on the Moon.",
  "source": "https://…"
}
```

- `key` is lowercase and hyphenated. It's what appears in links (`?a=first-flight&b=apollo-11-moon-landing`).
- `date` is as precise as you know it: `"1969"`, `"1969-07"`, or `"1969-07-20"`. Use negative years for BCE (`"-43"` is 44 BCE). Dates before 1582 should stay year-only, since the math uses the Gregorian calendar.
- `title` is the heading in lists and on the timeline.
- `phrase` has to read in the middle of a sentence: "we'll be further from *the Apollo 11 Moon landing* than it was from *the Wright brothers' first flight*." Include the article.
- `description` and `source` are optional.

`node --test test/*.test.mjs` checks for missing fields, duplicate keys, and bad dates. CI runs it before every deploy.

When adding a batch, `scripts/check-dates` compares each event's date with
Wikidata's dates for its Wikipedia `source` (or pass a TSV of `date<TAB>title`
to vet candidates first). `!!` means no date matched, often because Wikidata has
a different date for the article, so check the article itself.
`scripts/check-claims` takes a TSV of `title<TAB>regex` and prints the matching
sentences, and `scripts/upcoming` shows what the batch does to the upcoming feed.

## How the comparison works

Two events are compared at the coarser of their two precisions. Two exact dates
are compared to the day, a day and a month to the month, and anything with a
year-only date to the year. The page says when that happens.

Any year or date also works in place of an event key: `?a=1999-12-31&b=apollo-11-moon-landing`.
