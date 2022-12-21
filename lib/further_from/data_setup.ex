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
        year: 1903
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
        short_name: "NES release"
      },
      %{
        key: "snes",
        name: "release of the Super Nintendo Entertainment System (SNES) in North America",
        category: "videogames",
        year: 1991,
        short_name: "SNES release"
      },
      %{
        key: "earliest-videogame",
        name: "earliest known publicly demonstrated electronic game",
        category: "videogames",
        year: 1950
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
      }
    ]
    |> Enum.each(fn attrs ->
      %Event{}
      |> Event.changeset(attrs)
      |> Repo.insert!()
    end)
  end
end
