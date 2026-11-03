// What the pages share: building elements, a few words, and loading the events.
// A plain script like when.js: it sets window.Site, and each page loads it
// with a <script> tag after when.js.

(function (root) {
  const W = root.When;

  const $ = (id) => document.getElementById(id);

  function el(tag, attrs = {}, ...kids) {
    const node = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs)) {
      if (v == null || v === false) continue;
      if (k === "class") node.className = v;
      else if (k === "style") node.style.cssText = v;
      else if (k.startsWith("on")) node.addEventListener(k.slice(2), v);
      else node.setAttribute(k, v === true ? "" : v);
    }
    for (const kid of kids.flat(Infinity)) if (kid != null && kid !== false) node.append(kid);
    return node;
  }

  // like append, but skips the null and false that conditional children leave behind
  function fill(node, ...kids) {
    node.replaceChildren(...kids.flat(Infinity).filter((k) => k != null && k !== false));
  }

  const cap = (s) => s.charAt(0).toUpperCase() + s.slice(1);

  function short(t) {
    return W.format(t, "short");
  }

  // the ages from W.agesAt, as "age 40" or "age 39–40"
  function ageLabel([young, old]) {
    if (young === null) return "around birth";
    return young === old ? `age ${old}` : `age ${young}–${old}`;
  }

  // a day as YYYY-MM-DD, for a date input or a link
  function isoDate(t) {
    return `${String(t.y).padStart(4, "0")}-${String(t.m).padStart(2, "0")}-${String(t.d).padStart(2, "0")}`;
  }

  // "in 3 years, 2 months", "4 days ago", or "today", for a comparison's crossover
  function fromNow(c) {
    if (c.tense === "present") return ["this year", "this month", "today"][c.p];
    return c.tense === "future" ? `in ${W.distance(c.pivot)}` : `${W.distance(c.pivot)} ago`;
  }

  // the page for one event
  function eventHref(key) {
    return `event.html?${new URLSearchParams({ e: key })}`;
  }

  function sourceLink(url) {
    return el("a", { class: "source", href: url, target: "_blank", rel: "noopener" },
      "Source", el("span", { "aria-hidden": "true" }, " ↗"));
  }

  // a row on a lifetime timeline that marks a moment instead of an event
  function lifeMark(age, date, title) {
    return el("li", {}, el("div", { class: "life-row mark" },
      el("span", { class: "life-age" }, age),
      el("span", { class: "life-date" }, date),
      el("span", { class: "life-title" }, title)));
  }

  // the chips that narrow a list of events to one type: "all" and then one
  // chip per category, each with its number of events. counts maps each
  // category to that number, current is the chosen category or null for all,
  // and onpick gets the category clicked, or null for "all".
  function categoryChips(counts, current, onpick) {
    const total = [...counts.values()].reduce((a, b) => a + b, 0);
    return [null, ...[...counts.keys()].sort()].map((cat) => el("button", {
      class: "chip", type: "button", "aria-pressed": String(current === cat),
      onclick: () => onpick(cat),
    }, `${cat ?? "all"} ${cat ? counts.get(cat) : total}`));
  }

  async function json(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`${url}: ${res.status}`);
    return res.json();
  }

  const byStart = (x, y) => W.span(x.when)[0] - W.span(y.when)[0];

  // the page for someone's lifetime
  function lifeHref(person) {
    const params = new URLSearchParams({ name: person.name, born: person.born });
    if (person.died) params.set("died", person.died);
    return `life.html?${params}`;
  }

  // a person's birth and, if they've died, their death, as events in the births and deaths categories
  function personEvents(person) {
    const base = { description: person.description, source: person.source, person };
    return [
      { ...base, key: `${person.key}-born`, category: "births", date: person.born, title: `${person.name} is born`, phrase: `${person.name}'s birth` },
      person.died ? { ...base, key: `${person.key}-died`, category: "deaths", date: person.died, title: `${person.name} dies`, phrase: `${person.name}'s death` } : null,
    ].filter(Boolean);
  }

  // everyone in people.json, oldest first, with their birth as when and their death as died
  async function loadPeople() {
    return (await json("people.json"))
      .map((p) => ({ ...p, when: W.parse(p.born), diedWhen: p.died ? W.parse(p.died) : null }))
      .filter((p) => p.when)
      .sort(byStart);
  }

  // every event, oldest first, from the category files that events/index.json
  // lists and from the births and deaths of everyone in people.json
  async function loadEvents() {
    const [cats, people] = await Promise.all([json("events/index.json"), json("people.json")]);
    const files = await Promise.all(cats.map((cat) => json(`events/${cat}.json`)));
    return [...files.flat(), ...people.flatMap(personEvents)]
      .map((e) => ({ ...e, when: W.parse(e.date) }))
      .filter((e) => e.when)
      .sort(byStart);
  }

  // the theme toggle in the nav flips between light and dark, showing a moon or
  // a sun for the theme it switches to. A choice that matches the system's is
  // forgotten, so the page follows the system again.
  function themeToggle() {
    const button = $("theme");
    if (!button) return;
    const svg = (d) => `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="${d}"/></svg>`;
    const icons = {
      dark: svg("M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5z"), // moon
      light: svg("M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8zM12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"), // sun
    };
    const systemDark = matchMedia("(prefers-color-scheme: dark)");
    const system = () => (systemDark.matches ? "dark" : "light");
    const html = document.documentElement;
    const current = () => html.dataset.theme || system();
    const render = () => {
      const next = current() === "dark" ? "light" : "dark";
      button.innerHTML = icons[next];
      button.title = `Switch to the ${next} theme`;
      button.setAttribute("aria-label", button.title);
    };
    const set = (theme) => {
      if (theme === "light" || theme === "dark") html.dataset.theme = theme;
      else delete html.dataset.theme;
      render();
    };
    button.addEventListener("click", () => {
      const next = current() === "dark" ? "light" : "dark";
      const choice = next === system() ? null : next;
      try {
        if (choice) localStorage.setItem("theme", choice);
        else localStorage.removeItem("theme");
      } catch (e) {}
      set(choice);
    });
    systemDark.addEventListener("change", render);
    // keep other open tabs in step
    addEventListener("storage", (e) => { if (e.key === "theme") set(e.newValue); });
    render();
    button.hidden = false;
  }
  themeToggle();

  root.Site = { $, el, fill, cap, short, isoDate, fromNow, eventHref, lifeHref, sourceLink, ageLabel, lifeMark, categoryChips, loadEvents, loadPeople };
})(window);
