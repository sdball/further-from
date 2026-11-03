import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import vm from "node:vm";

const context = {};
vm.runInNewContext(readFileSync(new URL("../public/when.js", import.meta.url), "utf8"), context);
const { When } = context;
const people = JSON.parse(readFileSync(new URL("../public/people.json", import.meta.url), "utf8"));
const dir = new URL("../public/events/", import.meta.url);
const events = readdirSync(dir).filter((f) => f.endsWith(".json") && f !== "index.json")
  .flatMap((f) => JSON.parse(readFileSync(new URL(f, dir), "utf8")));

const FIELDS = ["key", "name", "born", "died", "description", "source"];
// the life page asks for a death date past this age
const OLDEST = 130;

test("everyone is complete", () => {
  for (const p of people) {
    for (const field of ["key", "name", "born", "description", "source"]) {
      assert.ok(typeof p[field] === "string" && p[field].trim(), `${p.key ?? "?"} needs a ${field}`);
    }
    for (const field of Object.keys(p)) assert.ok(FIELDS.includes(field), `${p.key} has an unknown field "${field}"`);
  }
});

test("keys are unique, lowercase, and hyphenated", () => {
  const seen = new Set();
  for (const { key } of people) {
    assert.match(key, /^[a-z0-9]+(-[a-z0-9]+)*$/, key);
    assert.ok(!seen.has(key), `duplicate key ${key}`);
    seen.add(key);
  }
});

test("births and deaths don't share a key with an event", () => {
  // site.js turns each person into events keyed key-born and key-died
  const keys = new Set(events.map((e) => e.key));
  for (const { key } of people) {
    for (const suffix of ["born", "died"]) assert.ok(!keys.has(`${key}-${suffix}`), `${key}-${suffix} is already an event`);
  }
});

test("births and deaths aren't event categories", () => {
  // site.js puts people's births and deaths there, so events would mix in with them
  for (const e of events) assert.ok(!["births", "deaths"].includes(e.category), `${e.key} is in ${e.category}`);
});

test("names are unique", () => {
  // the life page knows someone by their name and birth
  const names = people.map((p) => p.name);
  assert.equal(new Set(names).size, names.length);
});

test("births and deaths are real dates, in order, and not in the future", () => {
  const today = When.value(When.today(), When.DAY);
  for (const p of people) {
    const born = When.parse(p.born);
    assert.ok(born, `${p.key} has a bad birth "${p.born}"`);
    assert.ok(When.span(born)[0] <= today, `${p.key} hasn't been born yet`);
    if (p.died === undefined) {
      assert.ok(When.agesAt(When.span(born), When.today())[0] <= OLDEST, `${p.key} would be over ${OLDEST}, so needs a death`);
      continue;
    }
    const died = When.parse(p.died);
    assert.ok(died, `${p.key} has a bad death "${p.died}"`);
    assert.ok(When.span(died)[1] >= When.span(born)[0], `${p.key} dies before being born`);
    assert.ok(When.span(died)[0] <= today, `${p.key} hasn't died yet`);
  }
});

test("dates before the Gregorian calendar stay at year precision", () => {
  for (const p of people) {
    for (const date of [p.born, p.died].filter(Boolean)) {
      const t = When.parse(date);
      assert.ok(t.y >= 1582 || t.p === When.YEAR, `${p.key} has ${date}, before 1582, so give only its year`);
    }
  }
});
