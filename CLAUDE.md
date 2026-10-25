# CLAUDE.md

Read README.md first. It covers the layout, running locally, the event format,
and the vetting scripts. This file covers what the README doesn't.

## Ground rules

- No build step, no dependencies, no package.json. Keep it that way: plain
  HTML, CSS, and JS in `public/`, Node's built-in test runner, and the scripts
  use only the standard library (Python 3 and Node).
- `public/when.js` is a plain script, not a module. It sets `window.When`, the
  page loads it with a `<script>` tag, and the tests and `scripts/upcoming` load
  it with `vm.runInNewContext`. Don't turn it into an ES module or add
  `require`/`import` to it.
- Pushing to `main` deploys. CI runs `node --test test/*.test.mjs`, then checks
  that every `.html` file in `public/` has the GoatCounter snippet
  (`data-goatcounter="https://sdball.goatcounter.com/count"`). A new page
  needs that snippet.
- The git history before "Rebuild Further From as a static site" is an old
  Elixir/Phoenix app. Ignore it.

## The page

`public/index.html` is the whole app: styles, markup, and one inline script
split into `// ---------- Section ----------` blocks (URL state, Comparison,
Picker, What if, Crossovers on the calendar, In your lifetime, Events, Start).
Put new code in the section it belongs to, and match the style: the `el()` and
`$()` helpers, one `state` object, and `render*` functions.

- Colors are CSS custom properties on `:root`, with a dark theme under
  `prefers-color-scheme` and `[data-theme]`. Use the tokens, not literal colors.
- Respect `prefers-reduced-motion` (see `reduceMotion`), keep the ARIA labels
  and live regions, and keep keyboard support working (`/` focuses search, `r`
  picks another pair, arrow keys walk the list).
- `PAIRS` near the top of the script lists the "Interesting pairs" by event
  key. No test checks it, so if you rename or remove a key, update `PAIRS`
  too. Renaming a key also breaks links people have shared, so avoid it.

## Date math

All date logic lives in `when.js` and is tested in `test/when.test.mjs`.
Moments are `{ p, y, m, d }` with precision 0 year, 1 month, 2 day. Years are
astronomical (0 is 1 BCE) on the proleptic Gregorian calendar. Day numbers come
from Hinnant's algorithm because `Date.UTC` maps years 0–99 onto the 1900s, so
don't use `Date` for historical dates. Add a test for any change here.

## Adding events

Follow the README's format. Beyond what the tests enforce:

- Every event has a `source`, usually an English Wikipedia link. Keep it that
  way, since `scripts/check-dates` works from those links.
- Vet a batch before committing: `scripts/check-dates` for the dates,
  `scripts/check-claims` for each factual claim in a description, and
  `scripts/upcoming` to see what the batch does to the upcoming feed. These
  scripts call Wikidata and Wikipedia. Put their TSV input files in a scratch
  directory, not the repo.
- Descriptions are a sentence or three: plain, specific, and allowed to be
  playful (see `nes`). Don't tell an event only the way a traditional US
  history class would when that version leaves out the people on the other
  side of it, such as the Native peoples whose land it was.
  `mount-rushmore-completed` is the model: it starts from the Lakota's Six
  Grandfathers Mountain and the broken Fort Laramie treaty, not from the
  carving. Back that perspective with the source. The point is a fuller
  picture, not a list of every harm. The site leans toward lighter history
  and keeps wars and assassinations to a minimum.
- Use an existing `category` if one fits (`history`, `videogames`, `movies`,
  `space`, `technology`, `internet`, `programming`, `books`, `music`,
  `business`). Each category becomes a filter chip.

## Commits

Short imperative subjects in sentence case, no prefixes ("Add 1980s videogame
events, with Infocom, Lucasarts, Nintendo, and Sega"). Run the tests before
committing.
