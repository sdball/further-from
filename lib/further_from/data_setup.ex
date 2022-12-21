defmodule FurtherFrom.DataSetup do
  alias FurtherFrom.Timeline.Event
  alias FurtherFrom.Repo

  def init do
    delete_all()
    create_events()
  end

  def delete_all() do
    Repo.delete_all(Event)
  end

  def create_events() do
    [
      %{
        key: "beastmaster-movie-release",
        name: "release of the movie The Beastmaster",
        category: "movies",
        year: 1982,
        description: "One of the pinnacle achievements of the sword and sorcery movie genre."
      },
      %{
        key: "conan-the-barbarian-movie-release",
        name: "release of the movie Conan the Barbarian",
        category: "movies",
        year: 1982,
        description:
          "Conan the Barbarian earned lead actor Arnold Schwarzenegger worldwide recognition."
      },
      %{
        key: "apollo-11-moon-landing",
        name: "Apollo 11 Moon Landing",
        category: "space",
        year: 1969,
        description:
          "Apollo 11 (July 16–24, 1969) was the American spaceflight that first landed humans on the Moon."
      },
      %{
        key: "first-flight",
        name: "Wright brothers' first flight",
        category: "technology",
        year: 1903,
        description:
          "The Wright Brothers did not solely rely on engine power to lift their flying machines off the ground. Instead, they emphasized the importance of piloting skills. Through over a thousand gliding flights from the top of Kill Devil Hill, the brothers were able to identify the engineering principles that allow for lift and the necessary controls to maintain an aircraft in flight."
      },
      %{
        key: "forrest-gump-in-vietnam-war",
        name: "character Forrest Gump being in the Vietnam War",
        category: "movies",
        year: 1967
      },
      %{
        key: "forrest-gump-movie-release",
        name: "release of the movie Forrest Gump",
        category: "movies",
        year: 1994
      },
      %{
        key: "nes",
        name: "release of the Nintendo Entertainment System (NES) in North America",
        category: "videogames",
        year: 1985,
        short_name: "NES release",
        description: "The NES ran at 60FPS… unless you had a bunch of sprites on the screen."
      },
      %{
        key: "snes",
        name: "release of the Super Nintendo Entertainment System (SNES) in North America",
        category: "videogames",
        year: 1991,
        short_name: "SNES release",
        description: "No more hard angles on these controllers. And six action buttons!"
      },
      %{
        key: "earliest-videogame",
        name: "earliest known publicly demonstrated electronic game",
        category: "videogames",
        year: 1950,
        description:
          "The earliest known publicly demonstrated electronic game was created in 1950. Bertie the Brain was an arcade game of tic-tac-toe, built by Josef Kates for the 1950 Canadian National Exhibition."
      },
      %{
        key: "first-clamshell-laptop",
        name: "first clamshell laptop (GRiD Compass)",
        category: "technology",
        year: 1982,
        description:
          "The GRiD Compass was the first clamshell laptop. It weighed 10 pounds but is still considered the first truly portable laptop computer."
      },
      %{
        key: "gutenberg-printing-press",
        name: "Gutenberg printing press introduced in Europe",
        category: "technology",
        year: 1439,
        description:
          "Around this time Johannes Gutenberg, of the German city of Mainz, introduced the printing press to Europe."
      },
      %{
        key: "first-movie",
        name: "first movie ever recorded",
        category: "movies",
        year: 1878,
        description:
          "An 11-frame clip of man riding a horse. It was recorded by Eadweard Eadweard using 12 separate cameras that he designed to have a then cutting edge 1/25th of a second shutter speed. He also designed the zoöpraxiscope as a mechanism to view the photos as a movie."
      },
      %{
        key: "elixir-lang",
        name: "Elixir language was introduced",
        category: "programming",
        year: 2012,
        description:
          "In 2012 José Valim publicly introduced Elixir to the world as a new syntactially approachable language for the BEAM. Now extremely popular and noted for its ease of use, scalability, and reliably."
      },
      %{
        key: "javascript-lang",
        name: "JavaScript language was introduced",
        category: "programming",
        year: 1995,
        description:
          "Long ago JavaScript was safely trapped within browser engines. Then everything changed when Google open sourced Chrome and developers used its JavaScript execution engine to build a server-side JavaScript runtime that we now call NodeJS."
      },
      %{
        key: "ruby-lang",
        name: "Ruby language was introduced",
        category: "programming",
        year: 1995,
        description:
          "Ruby is an interpreted, high-level, scripting language with a strong foundation in object oriented programming and famously expressive syntax. In the words of creator Yukihiro Matsumoto: \"I really wanted a genuine object-oriented, easy-to-use scripting language. I looked for but couldn't find one. So I decided to make it.\""
      },
      %{
        key: "python-lang",
        name: "Python programming language was introduced",
        category: "programming",
        year: 1991,
        description:
          "Introduced in 1991 by Guido van Rossum. Python was designed to have a small core, large standard library, and to be easily extensible via modules. That foundational design has kept Python popular in the decades since."
      },
      %{
        key: "zork-i-released",
        name: "release of Zork I",
        category: "videogames",
        year: 1980,
        description:
          "Arguably the most famous work of interactive fiction and a huge financial success for Infocom. In 2007, Zork was noted by the Library of Congress as one of the ten most important video games of all time."
      },
      %{
        key: "rocket-league-released",
        name: "release of Rocket League",
        category: "videogames",
        year: 2015,
        description:
          "Soccer. With cars. That are also rockets. A simple game with a simple premise and simple controls that ends up having a surprisingly deep skill well with innovative mechanics still being discovered even years later."
      },
      %{
        key: "secret-of-monkey-island-released",
        name: "release of The Secret of Monkey Island",
        category: "videogames",
        year: 1990,
        description:
          "One of the foundational works of point and click gaming. Frustrated with the \"gotcha!\" deaths and unwinnable states of contemporary adventure games, creators Ron Gilbert and Tim Schafer designed Monkey Island so that it was always possible to win. A design choice that continued through the rest of Lucasarts adventure games."
      }
    ]
    |> Enum.each(fn attrs ->
      %Event{}
      |> Event.changeset(attrs)
      |> Repo.insert!()
    end)
  end
end
