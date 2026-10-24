// Date math for Further From. A plain script: the page loads it with a
// <script> tag and the tests load it with node's vm module.
//
// A moment is { p, y, m, d } where p is its precision: 0 year, 1 month, 2 day.
// Years count astronomically (0 is 1 BCE, -43 is 44 BCE), and every date is
// on the proleptic Gregorian calendar, so keep anything before 1582 to the year.

(function (root) {
  const YEAR = 0, MONTH = 1, DAY = 2;
  const MONTHS = ["January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December"];

  // ---------- Parsing ----------

  const DATE_RE = /^(-?\d{1,6})(?:-(\d{2})(?:-(\d{2}))?)?$/;

  function parse(text) {
    const match = DATE_RE.exec(String(text).trim());
    if (!match) return null;
    const y = Number(match[1]);
    const m = match[2] === undefined ? 1 : Number(match[2]);
    const d = match[3] === undefined ? 1 : Number(match[3]);
    const p = match[3] !== undefined ? DAY : match[2] !== undefined ? MONTH : YEAR;
    if (m < 1 || m > 12 || d < 1 || d > daysInMonth(y, m)) return null;
    return { p, y, m, d };
  }

  function isLeap(y) {
    return (y % 4 === 0 && y % 100 !== 0) || y % 400 === 0;
  }

  function daysInMonth(y, m) {
    return m === 2 ? (isLeap(y) ? 29 : 28) : [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][m - 1];
  }

  // ---------- Day numbers ----------
  // days since 1970-01-01, from Howard Hinnant's civil calendar algorithms.
  // Date.UTC would do, except it maps years 0 through 99 onto the 1900s.

  function dayNumber(y, m, d) {
    if (m <= 2) y -= 1;
    const era = Math.floor(y / 400);
    const yoe = y - era * 400;
    const doy = Math.floor((153 * ((m + 9) % 12) + 2) / 5) + d - 1;
    const doe = yoe * 365 + Math.floor(yoe / 4) - Math.floor(yoe / 100) + doy;
    return era * 146097 + doe - 719468;
  }

  function fromDayNumber(z) {
    z += 719468;
    const era = Math.floor(z / 146097);
    const doe = z - era * 146097;
    const yoe = Math.floor((doe - Math.floor(doe / 1460) + Math.floor(doe / 36524) - Math.floor(doe / 146096)) / 365);
    const doy = doe - (365 * yoe + Math.floor(yoe / 4) - Math.floor(yoe / 100));
    const mp = Math.floor((5 * doy + 2) / 153);
    const d = doy - Math.floor((153 * mp + 2) / 5) + 1;
    const m = mp < 10 ? mp + 3 : mp - 9;
    return { y: yoe + era * 400 + (m <= 2 ? 1 : 0), m, d };
  }

  // ---------- Moments at a precision ----------

  // a single number for a moment, counted in years, months, or days
  function value(t, p) {
    if (p === YEAR) return t.y;
    if (p === MONTH) return t.y * 12 + (t.m - 1);
    return dayNumber(t.y, t.m, t.d);
  }

  function fromValue(v, p) {
    if (p === YEAR) return { p, y: v, m: 1, d: 1 };
    if (p === MONTH) return { p, y: Math.floor(v / 12), m: (((v % 12) + 12) % 12) + 1, d: 1 };
    return { p, ...fromDayNumber(v) };
  }

  // the first and last day a moment covers
  function span(t) {
    if (t.p === YEAR) return [dayNumber(t.y, 1, 1), dayNumber(t.y, 12, 31)];
    if (t.p === MONTH) return [dayNumber(t.y, t.m, 1), dayNumber(t.y, t.m, daysInMonth(t.y, t.m))];
    const n = dayNumber(t.y, t.m, t.d);
    return [n, n];
  }

  function today(now = new Date()) {
    return { p: DAY, y: now.getFullYear(), m: now.getMonth() + 1, d: now.getDate() };
  }

  // ---------- Comparing ----------

  // Two events are compared at the coarser of their precisions: a day can be
  // measured against a month, but only to the month.
  function compare(a, b, now = today()) {
    const p = Math.min(a.when.p, b.when.p);
    const [first, last] = value(a.when, p) <= value(b.when, p) ? [a, b] : [b, a];
    const gap = value(last.when, p) - value(first.when, p);
    const pivot = fromValue(value(last.when, p) + gap, p);
    const nowValue = value(now, p);
    const pivotValue = value(pivot, p);
    const tense = gap === 0 ? "same" : pivotValue < nowValue ? "past" : pivotValue > nowValue ? "future" : "present";
    return { p, first, last, gap, pivot, tense };
  }

  // where the other event lands if one of a comparison's events moves to t,
  // keeping the gap between them
  function shift(c, moved, t) {
    const sign = moved === c.last ? -1 : 1;
    return fromValue(value(t, c.p) + sign * c.gap, c.p);
  }

  // calendar years, months, and days from one day to a later one
  function between(a, b) {
    let months = (b.y * 12 + b.m) - (a.y * 12 + a.m);
    if (b.d < a.d) months -= 1;
    // step a forward by whole months, holding a 31st to the end of shorter months
    const v = a.y * 12 + (a.m - 1) + months;
    const y = Math.floor(v / 12), m = v - y * 12 + 1;
    const anchor = dayNumber(y, m, Math.min(a.d, daysInMonth(y, m)));
    return { years: Math.floor(months / 12), months: months % 12, days: dayNumber(b.y, b.m, b.d) - anchor };
  }

  // ---------- Words ----------

  function plural(n, one, many = one + "s") {
    return `${n.toLocaleString("en-US")} ${n === 1 ? one : many}`;
  }

  function yearText(y) {
    return y > 0 ? String(y) : `${1 - y} BCE`;
  }

  function format(t, style = "long") {
    const month = style === "short" ? MONTHS[t.m - 1].slice(0, 3) : MONTHS[t.m - 1];
    if (t.p === YEAR) return yearText(t.y);
    if (t.p === MONTH) return `${month} ${yearText(t.y)}`;
    return `${month} ${t.d}, ${yearText(t.y)}`;
  }

  // "in 2035", "in February 2035", "on February 21, 2035"
  function when(t) {
    return (t.p === DAY ? "on " : "in ") + format(t);
  }

  // a gap counted in the comparison's own units
  function gapText(gap, p) {
    if (p === YEAR) return plural(gap, "year");
    if (p === MONTH) {
      const y = Math.floor(gap / 12), m = gap % 12;
      if (!y) return plural(m, "month");
      return m ? `${plural(y, "year")}, ${plural(m, "month")}` : plural(y, "year");
    }
    return plural(gap, "day");
  }

  // the rough calendar length of a gap of days, or null when days say it all
  function roughly(first, last) {
    const { years, months } = between(first, last);
    if (!years && !months) return null;
    const parts = [];
    if (years) parts.push(plural(years, "year"));
    if (months) parts.push(plural(months, "month"));
    return "about " + parts.join(", ");
  }

  // how far a moment is from now, in the units it was measured in
  function distance(t, now = today()) {
    if (t.p === DAY) {
      const [a, b] = value(t, DAY) < value(now, DAY) ? [t, now] : [now, t];
      const days = value(b, DAY) - value(a, DAY);
      const { years, months } = between(a, b);
      if (!years && !months) return plural(days, "day");
      const parts = [];
      if (years) parts.push(plural(years, "year"));
      if (months) parts.push(plural(months, "month"));
      return parts.join(", ");
    }
    return gapText(Math.abs(value(t, t.p) - value(now, t.p)), t.p);
  }

  root.When = {
    YEAR, MONTH, DAY, parse, dayNumber, fromDayNumber, value, fromValue, span,
    today, compare, shift, between, format, when, gapText, roughly, distance, plural, yearText,
  };
})(typeof window !== "undefined" ? window : globalThis);
