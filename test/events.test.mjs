import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import vm from "node:vm";

const context = {};
vm.runInNewContext(readFileSync(new URL("../public/when.js", import.meta.url), "utf8"), context);
const { When } = context;
const dir = new URL("../public/events/", import.meta.url);
const read = (name) => JSON.parse(readFileSync(new URL(name, dir), "utf8"));
const manifest = read("index.json");
const files = readdirSync(dir).filter((f) => f.endsWith(".json") && f !== "index.json");
const fileOf = new Map();
const events = files.flatMap((f) => read(f).map((e) => (fileOf.set(e, f), e)));

const FIELDS = ["key", "date", "title", "phrase", "category", "description", "source"];

test("the manifest lists every category file, sorted", () => {
  // the page can't list a directory, so it loads only what index.json names
  assert.deepEqual(manifest, files.map((f) => f.replace(/\.json$/, "")).sort());
});

test("each event is in its category's file", () => {
  for (const e of events) assert.equal(fileOf.get(e), `${e.category}.json`, `${e.key} is in ${fileOf.get(e)}`);
});

test("every event is complete", () => {
  for (const e of events) {
    for (const field of ["key", "date", "title", "phrase", "category"]) {
      assert.ok(typeof e[field] === "string" && e[field].trim(), `${e.key ?? "?"} needs a ${field}`);
    }
    for (const field of Object.keys(e)) assert.ok(FIELDS.includes(field), `${e.key} has an unknown field "${field}"`);
  }
});

test("keys are unique, lowercase, and hyphenated", () => {
  const seen = new Set();
  for (const { key } of events) {
    assert.match(key, /^[a-z0-9]+(-[a-z0-9]+)*$/, key);
    assert.ok(!seen.has(key), `duplicate key ${key}`);
    // a key that looks like a date would be read as a date in the URL
    assert.equal(When.parse(key), null, `${key} looks like a date`);
    seen.add(key);
  }
});

test("dates are real dates as YYYY, YYYY-MM, or YYYY-MM-DD", () => {
  for (const e of events) assert.ok(When.parse(e.date), `${e.key} has a bad date "${e.date}"`);
});

test("dates before the Gregorian calendar stay at year precision", () => {
  for (const e of events) {
    const t = When.parse(e.date);
    assert.ok(t.y >= 1582 || t.p === When.YEAR, `${e.key} is before 1582, so give only its year`);
  }
});

test("phrases read mid-sentence", () => {
  // "we'll be further from {phrase} than it was from {phrase}"
  for (const e of events) assert.doesNotMatch(e.phrase, /[.!?]$/, `${e.key} phrase ends with punctuation`);
});
