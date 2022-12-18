defmodule FurtherFrom.Event do
  defstruct [:key, :name, :keywords, :year, :category, :description, :short_name]

  def new(fields) do
    struct(FurtherFrom.Event, fields)
  end

  def lookup(collection, key) do
    event =
      collection
      |> Enum.find(fn event -> event.key == key end)

    if is_nil(event.short_name) do
      Map.put(event, :short_name, event.name)
    else
      event
    end
  end

  def with_keyword(collection, keyword) do
    collection
    |> Enum.filter(fn x ->
      Enum.member?(x.keywords, keyword)
    end)
  end

  def get_events() do
    [
      %FurtherFrom.Event{
        key: "beastmaster-movie-release",
        name: "The Beastmaster movie release",
        keywords: [:movie],
        category: :movies,
        year: 1982
      },
      %FurtherFrom.Event{
        key: "conan-the-barbarian-movie-release",
        name: "Conan the Barbarian movie release",
        keywords: [:movie],
        category: :movies,
        year: 1982,
        short_name: "Conan the Barbarian"
      },
      %FurtherFrom.Event{
        key: "apollo-11-moon-landing",
        name: "Apollo 11 Moon Landing",
        keywords: [:historic, :flight, :technology, :space],
        category: :space,
        year: 1969,
        description:
          "Apollo 11 (July 16–24, 1969) was the American spaceflight that first landed humans on the Moon."
      },
      %FurtherFrom.Event{
        key: "first-flight",
        name: "Wright brother's first flight",
        keywords: [:historic, :flight, :technology],
        category: :technology,
        year: 1903
      },
      %FurtherFrom.Event{
        key: "forrest-gump-in-vietnam-war",
        name: "character Forrest Gump being in the Vietnam War",
        keywords: [:movie, :event],
        category: :movies,
        year: 1967
      },
      %FurtherFrom.Event{
        key: "forrest-gump-movie-release",
        name: "Forrest Gump movie release",
        keywords: [:movie],
        category: :movies,
        year: 1994
      },
      %FurtherFrom.Event{
        key: "nes",
        name: "release of the Nintendo Entertainment System (NES) in North America",
        keywords: [:videogames],
        category: :videogames,
        year: 1985,
        short_name: "NES release"
      },
      %FurtherFrom.Event{
        key: "snes",
        name: "release of the Super Nintendo Entertainment System (SNES) in North America",
        keywords: [:videogames],
        category: :videogames,
        year: 1991,
        short_name: "SNES release"
      },
      %FurtherFrom.Event{
        key: "earliest-videogame",
        name: "earliest known publicly demonstrated electronic game",
        keywords: [:videogames],
        category: :videogames,
        year: 1950
      },
      %FurtherFrom.Event{
        key: "first-clamshell-laptop",
        name: "first clamshell laptop (GRiD Compass)",
        keywords: [:technology],
        category: :technology,
        year: 1982,
        description:
          "The GRiD Compass was the first clamshell laptop. It weighed 10 pounds but is still considered the first truly portable laptop computer."
      },
      %FurtherFrom.Event{
        key: "gutenberg-printing-press",
        name: "Gutenberg printing press introduced in Europe",
        keywords: [:technology],
        category: :technology,
        year: 1439,
        description:
          "Around this time Johannes Gutenberg, of the German city of Mainz, introduced the printing press to Europe."
      },
      %FurtherFrom.Event{
        key: "first-movie",
        name: "first movie ever recorded",
        keywords: [:technology, :movies],
        category: :movies,
        year: 1878,
        description: "An 11-frame clip of man riding a horse. It was recorded by Eadweard Eadweard using 12 separate cameras that he designed to have a then cutting edge 1/25th of a second shutter speed. He also designed the zoöpraxiscope as a mechanism to view the photos as a movie."
      }
    ]
  end
end

defimpl String.Chars, for: FurtherFrom.Event do
  def to_string(%FurtherFrom.Event{name: name, year: year}) do
    "#{name} (#{year})"
  end
end
