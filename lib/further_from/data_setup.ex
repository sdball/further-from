defmodule FurtherFrom.DataSetup do
  alias FurtherFrom.Timeline.Event
  alias FurtherFrom.Repo

  def init(_repo) do
    delete_events()
    load_events(source: :text) |> create_events()
  end

  def delete_events() do
    Repo.delete_all(Event)
  end

  def load_events(source: :text) do
    events_text()
    |> String.split("\n\n")
    |> Enum.map(fn event ->
      [key, summary, timeline, category, year | description] =
        String.split(event, "\n", trim: true)

      %{
        key: key,
        summary_text: summary,
        timeline_text: timeline,
        category: category,
        year: year,
        description: description |> Enum.join(" ")
      }
    end)
  end

  def load_events_inline(source: :code) do
    [
      %{
        category: "movies",
        description: "One of the pinnacle achievements of the sword and sorcery movie genre.",
        key: "beastmaster-movie-release",
        summary_text: "release of the movie The Beastmaster",
        timeline_text: "release of the movie The Beastmaster",
        year: "1982"
      },
      %{
        category: "movies",
        description:
          "Not as good as The Beastmaster, but Conan the Barbarian earned lead actor Arnold Schwarzenegger worldwide recognition.",
        key: "conan-the-barbarian-movie-release",
        summary_text: "release of the movie Conan the Barbarian",
        timeline_text: "release of the movie Conan the Barbarian",
        year: "1982"
      },
      %{
        category: "space",
        description:
          "Apollo 11 (July 16–24, 1969) was the American spaceflight that first landed humans on the Moon.",
        key: "apollo-11-moon-landing",
        summary_text: "Apollo 11 Moon Landing",
        timeline_text: "Apollo 11 Moon Landing",
        year: "1969"
      },
      %{
        category: "technology",
        description:
          "The Wright Brothers did not solely rely on engine power to lift their flying machines off the ground. Instead, they emphasized the importance of piloting skills. Through over a thousand gliding flights from the top of Kill Devil Hill, the brothers were able to identify the engineering principles that allow for lift and the necessary controls to maintain an aircraft in flight.",
        key: "first-flight",
        summary_text: "Wright brothers' first flight",
        timeline_text: "Wright brothers' first flight",
        year: "1903"
      },
      %{
        category: "movies",
        description: "",
        key: "forrest-gump-in-vietnam-war",
        summary_text: "character Forrest Gump being in the Vietnam War",
        timeline_text: "character Forrest Gump in the Vietnam War",
        year: "1967"
      },
      %{
        category: "movies",
        description: "",
        key: "forrest-gump-movie-release",
        summary_text: "release of the movie Forrest Gump",
        timeline_text: "release of the movie Forrest Gump",
        year: "1994"
      },
      %{
        category: "videogames",
        description: "The NES ran at 60FPS… unless you had a bunch of sprites on the screen.",
        key: "nes",
        summary_text: "NES release in North America",
        timeline_text: "Nintendo Entertainment System (NES) released in North America",
        year: "1985"
      },
      %{
        category: "videogames",
        description: "No more hard angles on these controllers. And six action buttons!",
        key: "snes",
        summary_text: "Super Nintendo being released in North America",
        timeline_text: "Super Nintendo Entertainment System (SNES) released in North America",
        year: "1991"
      },
      %{
        category: "videogames",
        description:
          "The earliest known publicly demonstrated electronic game was created in 1950. Bertie the Brain was an arcade game of tic-tac-toe, built by Josef Kates for the 1950 Canadian National Exhibition.",
        key: "earliest-electronic-game",
        summary_text: "earliest known publicly demonstrated electronic game",
        timeline_text: "earliest known publicly demonstrated electronic game",
        year: "1950"
      },
      %{
        category: "videogames",
        description:
          "\"Tennis for Two\" was the first videogame that was open to the general public. Prior games were entirely research projects or technology demonstrations. It was played on an oscilloscope which presented a side view of a tennis match. The custom built controller had a button to take a shot and a knob to adjust a shot's angle. Even this earliest videogame was very popular with long lines of people queuing up for a turn to play.",
        key: "earliest-videogame",
        summary_text: "earliest videogame",
        timeline_text: "earliest videogame",
        year: "1958"
      },
      %{
        category: "technology",
        description:
          "The GRiD Compass was the first clamshell laptop. It weighed 10 pounds but is still considered the first truly portable laptop computer.",
        key: "first-clamshell-laptop",
        summary_text: "first clamshell laptop (GRiD Compass)",
        timeline_text: "first clamshell laptop (GRiD Compass)",
        year: "1982"
      },
      %{
        category: "technology",
        description:
          "Around this time Johannes Gutenberg, of the German city of Mainz, introduced the printing press to Europe.",
        key: "gutenberg-printing-press",
        summary_text: "Gutenberg printing press being introduced in Europe",
        timeline_text: "Gutenberg printing press introduced in Europe",
        year: "1439"
      },
      %{
        category: "movies",
        description:
          "An 11-frame clip of man riding a horse. It was recorded by Eadweard Eadweard using 12 separate cameras that he designed to have a then cutting edge 1/25th of a second shutter speed. He also designed the zoöpraxiscope as a mechanism to view the photos as a movie.",
        key: "first-movie",
        summary_text: "first movie ever recorded",
        timeline_text: "first movie ever recorded",
        year: "1878"
      },
      %{
        category: "programming",
        description:
          "Developed and designed by Joe Armstrong, Erlang was originally proprietary to the Ericsson company. Erlang wasn't open sourced until years later in 1998. Erlang is fundamentally designed to be distributed, fault tolerant, soft realtime, and highly available. Erlang provides developer friendly concurrency abstractions, functional programming, and immutable data.",
        key: "erlang-lang",
        summary_text: "Erlang programming language being introduced",
        timeline_text: "Erlang programming language introduced",
        year: "1986"
      },
      %{
        category: "programming",
        description:
          "Jane Walerud is credited with the heroic effort of convincing Ericsson management that is was in everyone's best interest to open source Erlang and OTP. This was a monumental feat as the very term \"open-source\" had only even been coined a few months prior.",
        key: "erlang-open-sourced",
        summary_text: "Erlang programming language being open sourced",
        timeline_text: "Erlang programming language open sourced",
        year: "1998"
      },
      %{
        category: "programming",
        description:
          "In 2012 José Valim publicly introduced Elixir to the world as a new syntactically approachable language for the BEAM (Erlang's VM). Elixir has grown extremely popular in the years since and noted for its ease of use, scalability, and reliability. (And it's running this website!)",
        key: "elixir-lang",
        summary_text: "Elixir programming language being introduced",
        timeline_text: "Elixir programming language introduced",
        year: "2012"
      },
      %{
        category: "programming",
        description:
          "Long ago JavaScript was safely trapped within browser engines. Then everything changed when Google open sourced Chrome and developers used its JavaScript execution engine to build a server-side JavaScript runtime that we now call NodeJS.",
        key: "javascript-lang",
        summary_text: "JavaScript language being introduced",
        timeline_text: "JavaScript introduced",
        year: "1995"
      },
      %{
        category: "programming",
        description:
          "Ruby is an interpreted, high-level, scripting language with a strong foundation in object oriented programming and famously expressive syntax. In the words of creator Yukihiro Matsumoto: \"I really wanted a genuine object-oriented, easy-to-use scripting language. I looked for but couldn't find one. So I decided to make it.\"",
        key: "ruby-lang",
        summary_text: "Ruby programming language being introduced",
        timeline_text: "Ruby programming language introduced",
        year: "1995"
      },
      %{
        category: "programming",
        description:
          "Introduced in 1991 by Guido van Rossum. Python was designed to have a small core, large standard library, and to be easily extensible via modules. That foundational design has kept Python popular in the decades since.",
        key: "python-lang",
        summary_text: "Python programming language being introduced",
        timeline_text: "Python programming language introduced",
        year: "1991"
      },
      %{
        category: "videogames",
        description:
          "Arguably the most famous work of interactive fiction and a huge financial success for Infocom. In 2007, Zork was noted by the Library of Congress as one of the ten most important video games of all time.",
        key: "zork-i-released",
        summary_text: "release of Zork I",
        timeline_text: "Infocom released Zork I",
        year: "1980"
      },
      %{
        category: "videogames",
        description:
          "Soccer. With cars. That are also rockets. A simple game with a simple premise and simple controls that ends up having a surprisingly deep skill well with innovative mechanics still being discovered even years later.",
        key: "rocket-league-released",
        summary_text: "release of Rocket League",
        timeline_text: "Rocket League released",
        year: "2015"
      },
      %{
        category: "videogames",
        description:
          "One of the foundational works of point and click gaming. Frustrated with the \"gotcha!\" deaths and unwinnable states of contemporary adventure games, creators Ron Gilbert and Tim Schafer designed Monkey Island so that it was always possible to win. A design choice that continued through the rest of Lucasarts adventure games.",
        key: "secret-of-monkey-island-released",
        summary_text: "release of The Secret of Monkey Island",
        timeline_text: "Lucasarts released The Secret of Monkey Island",
        year: "1990"
      },
      %{
        category: "videogames",
        description:
          "A landmark game in the space combat genre. Developed by Chris Roberts who is now working to create Star Citizen.",
        key: "wing-commander-released",
        summary_text: "release of Wing Commander",
        timeline_text: "Origin Systems released Wing Commander",
        year: "1990"
      }
    ]
  end

  def create_events(events) do
    events
    |> Enum.each(fn attrs ->
      %Event{}
      |> Event.changeset(attrs)
      |> Repo.insert!()
    end)
  end

  def events_text do
    """
    beastmaster-movie-release
    release of the movie The Beastmaster
    release of the movie The Beastmaster
    movies
    1982
    One of the pinnacle achievements of the sword and sorcery movie genre.

    conan-the-barbarian-movie-release
    release of the movie Conan the Barbarian
    release of the movie Conan the Barbarian
    movies
    1982
    Not as good as The Beastmaster, but Conan the
    Barbarian earned lead actor Arnold
    Schwarzenegger worldwide recognition.


    apollo-11-moon-landing
    Apollo 11 Moon Landing
    Apollo 11 Moon Landing
    space
    1969
    Apollo 11 (July 16–24, 1969) was the American spaceflight that first landed
    humans on the Moon.

    first-flight
    Wright brothers' first flight
    Wright brothers' first flight
    technology
    1903
    The Wright Brothers did not solely rely on engine power to lift their flying
    machines off the ground. Instead, they emphasized the importance of piloting
    skills. Through over a thousand gliding flights from the top of Kill Devil
    Hill, the brothers were able to identify the engineering principles that allow
    for lift and the necessary controls to maintain an aircraft in flight.

    forrest-gump-in-vietnam-war
    character Forrest Gump being in the Vietnam War
    character Forrest Gump in the Vietnam War
    movies
    1967


    forrest-gump-movie-release
    release of the movie Forrest Gump
    release of the movie Forrest Gump
    movies
    1994


    nes
    NES release in North America
    Nintendo Entertainment System (NES) released in North America
    videogames
    1985
    The NES ran at 60FPS… unless you had a bunch of sprites on the screen.

    snes
    Super Nintendo being released in North America
    Super Nintendo Entertainment System (SNES) released in North America
    videogames
    1991
    No more hard angles on these controllers. And six action buttons!

    earliest-electronic-game
    earliest known publicly demonstrated electronic game
    earliest known publicly demonstrated electronic game
    videogames
    1950
    The earliest known publicly demonstrated electronic game was created in 1950.
    Bertie the Brain was an arcade game of tic-tac-toe, built by Josef Kates for
    the 1950 Canadian National Exhibition.

    earliest-videogame
    earliest videogame
    earliest videogame
    videogames
    1958
    "Tennis for Two" was the first videogame that was open to the general public.
    Prior games were entirely research projects or technology demonstrations. It
    was played on an oscilloscope which presented a side view of a tennis match.
    The custom built controller had a button to take a shot and a knob to adjust a
    shot's angle. Even this earliest videogame was very popular with long lines of
    people queuing up for a turn to play.

    first-clamshell-laptop
    first clamshell laptop (GRiD Compass)
    first clamshell laptop (GRiD Compass)
    technology
    1982
    The GRiD Compass was the first clamshell laptop. It weighed 10 pounds but is
    still considered the first truly portable laptop computer.

    gutenberg-printing-press
    Gutenberg printing press being introduced in Europe
    Gutenberg printing press introduced in Europe
    technology
    1439
    Around this time Johannes Gutenberg, of the German city of Mainz, introduced
    the printing press to Europe.

    first-movie
    first movie ever recorded
    first movie ever recorded
    movies
    1878
    An 11-frame clip of man riding a horse. It was recorded by Eadweard Eadweard
    using 12 separate cameras that he designed to have a then cutting edge 1/25th
    of a second shutter speed. He also designed the zoöpraxiscope as a mechanism
    to view the photos as a movie.

    erlang-lang
    Erlang programming language being introduced
    Erlang programming language introduced
    programming
    1986
    Developed and designed by Joe Armstrong, Erlang was originally proprietary to
    the Ericsson company. Erlang wasn't open sourced until years later in 1998.
    Erlang is fundamentally designed to be distributed, fault tolerant, soft
    realtime, and highly available. Erlang provides developer friendly concurrency
    abstractions, functional programming, and immutable data.

    erlang-open-sourced
    Erlang programming language being open sourced
    Erlang programming language open sourced
    programming
    1998
    Jane Walerud is credited with the heroic effort of convincing Ericsson
    management that is was in everyone's best interest to open source Erlang and
    OTP. This was a monumental feat as the very term "open-source" had only even
    been coined a few months prior.

    elixir-lang
    Elixir programming language being introduced
    Elixir programming language introduced
    programming
    2012
    In 2012 José Valim publicly introduced Elixir to the world as a new
    syntactically approachable language for the BEAM (Erlang's VM). Elixir has
    grown extremely popular in the years since and noted for its ease of use,
    scalability, and reliability. (And it's running this website!)

    javascript-lang
    JavaScript language being introduced
    JavaScript introduced
    programming
    1995
    Long ago JavaScript was safely trapped within browser engines. Then everything
    changed when Google open sourced Chrome and developers used its JavaScript
    execution engine to build a server-side JavaScript runtime that we now call
    NodeJS.

    ruby-lang
    Ruby programming language being introduced
    Ruby programming language introduced
    programming
    1995
    Ruby is an interpreted, high-level, scripting language with a strong
    foundation in object oriented programming and famously expressive syntax. In
    the words of creator Yukihiro Matsumoto: "I really wanted a genuine
    object-oriented, easy-to-use scripting language. I looked for but couldn't
    find one. So I decided to make it."

    python-lang
    Python programming language being introduced
    Python programming language introduced
    programming
    1991
    Introduced in 1991 by Guido van Rossum. Python was designed to have a small
    core, large standard library, and to be easily extensible via modules. That
    foundational design has kept Python popular in the decades since.

    zork-i-released
    release of Zork I
    Infocom released Zork I
    videogames
    1980
    Arguably the most famous work of interactive fiction and a huge financial
    success for Infocom. In 2007, Zork was noted by the Library of Congress as one
    of the ten most important video games of all time.

    rocket-league-released
    release of Rocket League
    Rocket League released
    videogames
    2015
    Soccer. With cars. That are also rockets. A simple game with a simple premise
    and simple controls that ends up having a surprisingly deep skill well with
    innovative mechanics still being discovered even years later.

    secret-of-monkey-island-released
    release of The Secret of Monkey Island
    Lucasarts released The Secret of Monkey Island
    videogames
    1990
    One of the foundational works of point and click gaming. Frustrated with
    the "gotcha!" deaths and unwinnable states of contemporary adventure games,
    creators Ron Gilbert and Tim Schafer designed Monkey Island so that it was
    always possible to win. A design choice that continued through the rest of
    Lucasarts adventure games.

    wing-commander-released
    release of Wing Commander
    Origin Systems released Wing Commander
    videogames
    1990
    A landmark game in the space combat genre by Chris Roberts who is now
    working to create Star Citizen.

    interstellar-movie-release
    release of the movie Interstellar
    Interstellar movie released
    movies
    2014
    Interstellar is a 2014 science fiction film directed by Christopher Nolan
    and starring Matthew McConaughey, Anne Hathaway, and Michael Caine. The
    film follows a group of astronauts who travel through a wormhole in search
    of a new home for humanity, as Earth is on the verge of environmental
    collapse. The story is based on scientific concepts such as relativity and
    gravity, and explores human themes of love and sacrifice.

    sinking-of-the-titanic
    sinking of the Titanic
    Titanic sinks
    history
    1912
    The Titanic was equipped with a number of innovative features, including
    electricity, elevators, and a swimming pool. It also had a gym, a Turkish
    bath, and a squash court. Its historic sinking is still one of the
    deadliest maritime disasters in history.

    release-of-the-movie-titanic
    release of the movie Titantic
    Titanic movie released
    movies
    1997
    It's hard to overstate how much of a media phenomenon Titanic was during
    its theatrical release. One interesting fact is that the set crew built a
    1:1 scale replica of the Titanic's Grand Staircase for the production.

    louisiana-purchase
    Louisiana Purchase
    Louisiana Purchase
    history
    1803
    The purchase doubled the size of the United States and was considered a
    major accomplishment of the presidency of Thomas Jefferson. The Louisiana
    Purchase was made possible by the Napoleonic Wars, which had left France in
    need of funds and weakened its hold on its North American colonies. In
    1803, the United States offered to purchase New Orleans and the land west
    of the Mississippi River for $10 million, but France instead offered to
    sell all of the Louisiana Territory, which included a much larger area, for
    $15 million.
    """
  end
end
