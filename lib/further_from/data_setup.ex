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
    In 1995 the Internet was a simpler place. Your browser client would make an
    HTTP request to a server and get a response back. Done and done. But the
    Netscape Communications Corporation wasn't satisfied. It wanted to bring
    interaction to the web. Interaction brought about by including a runtime in
    their browser to locally execute code sent from the web server. What could
    go wrong?

    nodejs-lang
    NodeJS programming language being introduced
    NodeJS programming language introduced
    programming
    2009
    Long ago JavaScript was safely trapped within browser engines. Then
    everything changed when Google open sourced Chrome and developers used its
    JavaScript execution engine to build a server-side JavaScript runtime that
    we now call NodeJS. Thus paving the pay for the left-pad incident.

    left-pad-incident
    left-pad incident
    left-pad incident
    programming
    2016
    In 2016 a developer named Azer Koçulu unpublished more than 250 of his
    JavaScript packages from the npm registry, a popular package manager for
    the JavaScript programming language. One of the packages that was
    unpublished was a very small library called left-pad, which provided a
    simple function for padding a string with a specified character on the left
    side. The removal of the left-pad package caused a chain reaction, as many
    other packages that depended on it were also affected. This led to
    widespread disruption and caused numerous projects to break.

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

    linux-open-sourced
    Linux operating system being open sourced
    Linux open sourced
    programming
    1991
    Linus Torvalds started developing Linux as a personal project while he was
    a student at the University of Helsinki in Finland. He released the first
    version of Linux, called version 0.01, on September 17, 1991. Since then,
    Linux has become one of the most widely used operating systems in the
    world, powering everything from servers and supercomputers to smartphones
    and embedded devices.

    bttf-movie-release
    release of the movie Back to the Future
    Back to the Future movie release
    movies
    1985
    Marty McFly is accidentally sent back in time to 1955 in a time-traveling
    DeLorean car built by Doc Brown. He meets his parents as teenagers and must
    ensure that they fall in love in order to return to his own time.

    bttf2-movie-release
    release of the movie Back to the Future II
    Back to the Future II movie release
    movies
    1989
    In this sequel, Marty and Doc travel to the future, specifically to the
    year 2015. Their goal is to prevent Marty's future son from making a
    terrible mistake but then they must travel back to 1955 to fix a
    destructive alteration to the timeline.

    bttf3-movie-release
    release of the movie Back to the Future III
    Back to the Future III movie release
    movies
    1990
    In the final movie of the trilogy, Marty must travel back in time to the
    Wild West and the year 1885. Marty must help Doc Brown, who became stranded
    in 1885 during the events of Back to the Future II.

    bttf-marty-in-1955
    character Marty McFly being stuck in 1955
    Marty McFly is stuck in 1955 during Back to the Future
    movies
    1955
    1.21 gigawatts! A bolt of lightning!

    future-time-of-bttf2
    the "future" time of Back to the Future II
    the "future" in Back to the Future II
    movies
    2015
    Hoverboards don't work on water, unless you've got POWER!

    past-time-of-bttf3
    Marty and Doc in the Wild West during Back to the Future III
    Marty and Doc in the Wild West during Back to the Future III
    movies
    1885
    Mr. Fusion powers the time circuits and the flux capacitor. But the
    internal combustion engine runs on ordinary gasoline, it always has.
    There's not going to be a gas station around here until sometime in the
    next century. Without gasoline, we can't get the DeLorean up to 88 miles
    per hour.
    """
  end
end
