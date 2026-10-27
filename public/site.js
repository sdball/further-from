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

  // a row on a lifetime timeline that marks a moment instead of an event
  function lifeMark(age, date, title) {
    return el("li", {}, el("div", { class: "life-row mark" },
      el("span", { class: "life-age" }, age),
      el("span", { class: "life-date" }, date),
      el("span", { class: "life-title" }, title)));
  }

  // every event, oldest first, from the category files that events/index.json lists
  async function loadEvents() {
    const json = async (url) => {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`${url}: ${res.status}`);
      return res.json();
    };
    const cats = await json("events/index.json");
    return (await Promise.all(cats.map((cat) => json(`events/${cat}.json`)))).flat()
      .map((e) => ({ ...e, when: W.parse(e.date) }))
      .filter((e) => e.when)
      .sort((x, y) => W.span(x.when)[0] - W.span(y.when)[0]);
  }

  root.Site = { $, el, fill, cap, short, ageLabel, lifeMark, loadEvents };
})(window);
