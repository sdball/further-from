# Further From

The static site behind https://furtherfrom.com. Pick two moments and find the
crossover: the moment we'll be further from the later one than it was from the
earlier one.

There's no build step and no dependencies. `public/` is the whole site, and
pushing to `main` deploys it to GitHub Pages.

```
public/index.html    the main page: comparison, picker, what if, upcoming crossovers, interesting pairs
public/event.html    one event: its details, the events nearest it, and its crossovers with every other event
public/anniversaries.html  what happened on a day of the year, and the anniversaries coming up
public/life.html     someone else's lifetime, from their birth and maybe their death
public/site.css      the styles, shared by every page
public/site.js       helpers and event loading, shared by every page
public/when.js       the date math, shared by the pages and the tests
public/events/       every event, one file per category, listed in index.json
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
scripts/serve --list # Python servers still running, with their pids
node --test test/*.test.mjs
```

Use the server rather than opening the files directly, since the pages fetch the event files.

## Adding an event

Add an object to the category's file in `public/events/`, such as
`public/events/space.json`. Order doesn't matter. A new category gets a new
file, and its name goes in `public/events/index.json`, since the page can't list
the directory and loads only what that names.

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

`node --test test/*.test.mjs` checks for missing fields, duplicate keys, bad dates,
events in the wrong file, and category files missing from `index.json`. CI runs it before every deploy.

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

`?view=` shows one card on its own: `comparison`, `what-if`, `calendar`, or
`pairs`. Each of those cards has a Focus button, and Escape shows everything
again.

`event.html?e=arpanet-first-message` is the page for one event: its details and
anniversary, the events closest to it in time, others on the same day of the
year, and its next crossovers with everything else. Without `?e=` it picks one
of today's anniversaries, or any event on a day with none.

`anniversaries.html` lists the events that happened on today's date (or
`?on=2026-12-25` for any other day), the anniversaries coming up after it, and
the next round-number anniversaries (multiples of 25 years) for every event.

`life.html` does the same for anyone else:
`life.html?name=Ada+Lovelace&born=1815-12-10&died=1852-11-27`. Only `born` is
needed. It lists every event from their birth to today with their age at each
one (or the years since they died), and when they'll have been gone as long as
they lived.
