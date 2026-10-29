import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import vm from "node:vm";

const context = {};
vm.runInNewContext(readFileSync(new URL("../public/when.js", import.meta.url), "utf8"), context);
const { When } = context;

const ev = (key, date) => ({ key, when: When.parse(date) });
const NOW = When.parse("2026-10-23");

test("parse reads the precision from the length of the date", () => {
  assert.deepEqual({ ...When.parse("1969") }, { p: 0, y: 1969, m: 1, d: 1 });
  assert.deepEqual({ ...When.parse("1969-07") }, { p: 1, y: 1969, m: 7, d: 1 });
  assert.deepEqual({ ...When.parse("1969-07-20") }, { p: 2, y: 1969, m: 7, d: 20 });
  assert.deepEqual({ ...When.parse("-43-03-15") }, { p: 2, y: -43, m: 3, d: 15 });
});

test("parse refuses dates that don't exist", () => {
  for (const bad of ["", "nes", "1969-13", "1969-00", "2023-02-29", "1969-7-20", "1969-07-20x"]) {
    assert.equal(When.parse(bad), null, bad);
  }
  assert.ok(When.parse("2024-02-29"));
});

test("day numbers round trip, including years before 100", () => {
  assert.equal(When.dayNumber(1970, 1, 1), 0);
  assert.equal(When.dayNumber(2000, 3, 1), 11017);
  for (const [y, m, d] of [[1, 1, 1], [0, 2, 29], [-43, 3, 15], [99, 12, 31], [1903, 12, 17], [2400, 2, 29]]) {
    assert.deepEqual({ ...When.fromDayNumber(When.dayNumber(y, m, d)) }, { y, m, d });
  }
});

test("two exact dates compare to the day", () => {
  const c = When.compare(ev("apollo", "1969-07-20"), ev("flight", "1903-12-17"), NOW);
  assert.equal(c.p, When.DAY);
  assert.equal(c.first.key, "flight");
  assert.equal(c.gap, 23957);
  assert.equal(When.format(c.pivot), "February 21, 2035");
  assert.equal(c.tense, "future");
});

test("mixed precision falls back to the coarser one", () => {
  const c = When.compare(ev("conan", "1982-05-14"), ev("beastmaster", "1982-08"), NOW);
  assert.equal(c.p, When.MONTH);
  assert.equal(c.gap, 3);
  assert.equal(When.format(c.pivot), "November 1982");
  assert.equal(c.tense, "past");

  const y = When.compare(ev("laptop", "1982"), ev("conan", "1982-05-14"), NOW);
  assert.equal(y.p, When.YEAR);
  assert.equal(y.tense, "same");
});

test("month math carries across years", () => {
  const c = When.compare(ev("a", "1999-11"), ev("b", "2000-02"), NOW);
  assert.equal(c.gap, 3);
  assert.equal(When.format(c.pivot), "May 2000");
  assert.equal(When.format(When.fromValue(-1, When.MONTH)), "December 2 BCE");
});

test("tense is measured at the comparison's precision", () => {
  assert.equal(When.compare(ev("a", "2020"), ev("b", "2023"), NOW).tense, "present");
  assert.equal(When.compare(ev("a", "2026-04"), ev("b", "2026-07"), NOW).tense, "present");
  assert.equal(When.compare(ev("a", "2026-10-21"), ev("b", "2026-10-22"), NOW).tense, "present");
  assert.equal(When.compare(ev("a", "2026-10-21"), ev("b", "2026-10-23"), NOW).tense, "future");
});

test("shift moves one event and keeps the gap", () => {
  const song = When.compare(ev("song", "1985-05-27"), ev("summer", "1969-06"), NOW);
  assert.equal(When.format(When.shift(song, song.last, NOW)), "November 2010");
  assert.equal(When.format(When.shift(song, song.first, NOW)), "September 2042");
  assert.equal(When.format(When.shift(song, song.last, song.last.when)), "June 1969");

  const c = When.compare(ev("apollo", "1969-07-20"), ev("flight", "1903-12-17"), NOW);
  assert.equal(When.format(When.shift(c, c.last, NOW)), "March 21, 1961");
  assert.equal(When.format(When.shift(c, c.first, NOW)), "May 26, 2092");
});

test("words", () => {
  assert.equal(When.gapText(23957, When.DAY), "23,957 days");
  assert.equal(When.gapText(15, When.MONTH), "1 year, 3 months");
  assert.equal(When.gapText(24, When.MONTH), "2 years");
  assert.equal(When.gapText(1, When.YEAR), "1 year");
  assert.equal(When.roughly(When.parse("1903-12-17"), When.parse("1969-07-20")), "about 65 years, 7 months");
  assert.equal(When.roughly(When.parse("2000-01-01"), When.parse("2000-01-20")), null);
  assert.equal(When.when(When.parse("1982-11")), "in November 1982");
  assert.equal(When.when(When.parse("1982-11-02")), "on November 2, 1982");
  assert.equal(When.format(When.parse("-43-03-15"), "short"), "Mar 15, 44 BCE");
  assert.equal(When.distance(When.parse("2035-02-21"), NOW), "8 years, 3 months");
  assert.equal(When.distance(When.parse("2026-11-01"), NOW), "9 days");
  assert.equal(When.distance(When.parse("2015"), NOW), "11 years");
  assert.equal(When.monthDay(When.parse("1969-10-29")), "October 29");
  assert.equal(When.monthDay(When.parse("1969-10-29"), "short"), "Oct 29");
  assert.deepEqual([1, 2, 3, 4, 11, 12, 13, 21, 57, 111, 1001].map(When.ordinal),
    ["1st", "2nd", "3rd", "4th", "11th", "12th", "13th", "21st", "57th", "111th", "1,001st"]);
});

test("an anniversary is the next time the day comes around", () => {
  const next = (date, now = "2026-10-23") => {
    const a = When.anniversary(When.parse(date), When.parse(now));
    return a && `${When.format(a.on)}, ${a.years}`;
  };
  assert.equal(next("1969-10-23"), "October 23, 2026, 57");
  assert.equal(next("1969-10-29"), "October 29, 2026, 57");
  assert.equal(next("1969-07-20"), "July 20, 2027, 58");
  assert.equal(next("2025-10-23"), "October 23, 2026, 1");
  assert.equal(next("-43-03-15"), "March 15, 2027, 2070");
  // a leap day waits for February 28 in a common year, and keeps its own day in a leap year
  assert.equal(next("2000-02-29", "2027-01-01"), "February 28, 2027, 27");
  assert.equal(next("2000-02-29", "2028-01-01"), "February 29, 2028, 28");
  // only a day has an anniversary, and only once it's happened
  assert.equal(next("1969-10"), null);
  assert.equal(next("1969"), null);
  assert.equal(next("2026-10-23"), null);
  assert.equal(next("2027-01-01"), null);
});

test("a milestone is the next anniversary that's a multiple of its years", () => {
  const next = (date, every, now = "2026-10-23") => {
    const a = When.milestone(When.parse(date), every, When.parse(now));
    return a && `${When.format(a.on)}, ${a.years}`;
  };
  assert.equal(next("1969-07-20", 25), "July 20, 2044, 75");
  assert.equal(next("1976-10-23", 25), "October 23, 2026, 50");
  assert.equal(next("1976-10-22", 25), "October 22, 2051, 75");
  assert.equal(next("2020-01-01", 25), "January 1, 2045, 25");
  // a month or a year counts until it's over
  assert.equal(next("1976-10", 25), "October 2026, 50");
  assert.equal(next("1976", 25), "2026, 50");
  assert.equal(next("1980", 25), "2030, 50");
  assert.equal(next("-43", 25), "2032, 2075");
  assert.equal(next("2000-02-29", 25, "2025-01-01"), "February 28, 2025, 25");
  assert.equal(next("2026", 25), null);
  assert.equal(next("2026-10", 25), null);
});

test("between borrows days from the right month", () => {
  assert.deepEqual({ ...When.between(When.parse("2024-01-31"), When.parse("2024-03-01")) }, { years: 0, months: 1, days: 1 });
  assert.deepEqual({ ...When.between(When.parse("2023-12-20"), When.parse("2024-01-05")) }, { years: 0, months: 0, days: 16 });
});

test("ages at a moment cover every birthday the birth range allows", () => {
  const exact = When.span(When.parse("1985-06-14"));
  assert.deepEqual([...When.agesAt(exact, When.parse("1997-06-13"))], [11, 11]);
  assert.deepEqual([...When.agesAt(exact, When.parse("1997-06-14"))], [12, 12]);
  assert.deepEqual([...When.agesAt(exact, When.parse("1997-06"))], [11, 12]);
  assert.equal(When.agesAt(exact, When.parse("1984")), null);
  assert.deepEqual([...When.agesAt(exact, When.parse("1985"))], [null, 0]);

  const year = When.span(When.parse("1985"));
  assert.deepEqual([...When.agesAt(year, When.parse("1997-06-14"))], [11, 12]);
  assert.deepEqual([...When.agesAt(year, When.parse("1986-06-14"))], [0, 1]);
});
