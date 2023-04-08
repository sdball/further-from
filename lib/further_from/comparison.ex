defmodule FurtherFrom.Comparison do
  @moduledoc """
  A Phoenix context for comparison data.  
  """

  defstruct [:pivot_year, :first, :last, :difference]

  alias FurtherFrom.Repo
  alias FurtherFrom.Comparison.RecentlySeen

  import Ecto.Query, only: [from: 2]

  @doc """
  Returns the list of recently_seen.

  ## Examples

      iex> list_recently_seen()
      [%RecentlySeen{}, ...]

  """
  def list_recently_seen do
    Repo.all(RecentlySeen)
  end

  def recently_seen(limit \\ 10) do
    query = from rs in RecentlySeen, order_by: [desc: rs.inserted_at], limit: ^limit
    Repo.all(query)
  end

  @doc """
  Gets a single recently_seen.

  Raises `Ecto.NoResultsError` if the Recently seen does not exist.

  ## Examples

      iex> get_recently_seen!(123)
      %RecentlySeen{}

      iex> get_recently_seen!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recently_seen!(id), do: Repo.get!(RecentlySeen, id)

  @doc """
  Creates a recently_seen.

  ## Examples

      iex> create_recently_seen(%{field: value})
      {:ok, %RecentlySeen{}}

      iex> create_recently_seen(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recently_seen(attrs \\ %{}) do
    %RecentlySeen{}
    |> RecentlySeen.changeset(attrs)
    |> Repo.insert(on_conflict: {:replace_all_except, [:id]})
  end

  @doc """
  Updates a recently_seen.

  ## Examples

      iex> update_recently_seen(recently_seen, %{field: new_value})
      {:ok, %RecentlySeen{}}

      iex> update_recently_seen(recently_seen, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recently_seen(%RecentlySeen{} = recently_seen, attrs) do
    recently_seen
    |> RecentlySeen.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recently_seen.

  ## Examples

      iex> delete_recently_seen(recently_seen)
      {:ok, %RecentlySeen{}}

      iex> delete_recently_seen(recently_seen)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recently_seen(%RecentlySeen{} = recently_seen) do
    Repo.delete(recently_seen)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recently_seen changes.

  ## Examples

      iex> change_recently_seen(recently_seen)
      %Ecto.Changeset{data: %RecentlySeen{}}

  """
  def change_recently_seen(%RecentlySeen{} = recently_seen, attrs \\ %{}) do
    RecentlySeen.changeset(recently_seen, attrs)
  end
end
