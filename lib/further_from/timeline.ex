defmodule FurtherFrom.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias FurtherFrom.Repo

  alias FurtherFrom.Timeline.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Gets a single event by key.

  Returns `nil` if the Event does not exist.

  ## Examples

      iex> get_event_by_key("first-flight")
      %Event{}

      iex> get_event_by_key("")
      nil

  """
  def get_event_by_key(key), do: Repo.get_by(Event, key: key)

  @doc """
  Gets a single event by key.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event_by_key!("first-flight")
      %Event{}

      iex> get_event_by_key!("")
      ** (Ecto.NoResultsError)

  """
  def get_event_by_key!(key), do: Repo.get_by!(Event, key: key)

  @doc """
  Gets a random event.
  """
  def get_random_event() do
    from(Event, order_by: fragment("RANDOM()"), limit: 1)
    |> Repo.one()
  end

  def get_random_event(omit: omit_event) do
    from(e in Event, where: e.key != ^omit_event.key, order_by: fragment("RANDOM()"), limit: 1)
    |> Repo.one()
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def build_year_event(year) when is_integer(year) do
    %{
      name: "year #{year}",
      short_name: "year #{year}",
      year: year
    }
  end

  def get_event_by_key_or_year(key) do
    event = FurtherFrom.Timeline.get_event_by_key(key)

    cond do
      is_nil(event) && Regex.match?(~r/\d\d\d\d/, key) ->
        Event.build_year_event(key |> String.to_integer())

      true ->
        event
    end
  end
end
