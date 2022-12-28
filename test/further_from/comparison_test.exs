defmodule FurtherFrom.ComparisonTest do
  use FurtherFrom.DataCase

  alias FurtherFrom.Comparison

  describe "recently_seen" do
    alias FurtherFrom.Comparison.RecentlySeen

    import FurtherFrom.ComparisonFixtures

    @invalid_attrs %{first_key: nil, first_timeline_text: nil, first_year: nil, last_key: nil, last_timeline_text: nil, last_year: nil, pivot_year: nil, region: nil}

    test "list_recently_seen/0 returns all recently_seen" do
      recently_seen = recently_seen_fixture()
      assert Comparison.list_recently_seen() == [recently_seen]
    end

    test "get_recently_seen!/1 returns the recently_seen with given id" do
      recently_seen = recently_seen_fixture()
      assert Comparison.get_recently_seen!(recently_seen.id) == recently_seen
    end

    test "create_recently_seen/1 with valid data creates a recently_seen" do
      valid_attrs = %{first_key: "some first_key", first_timeline_text: "some first_timeline_text", first_year: 42, last_key: "some last_key", last_timeline_text: "some last_timeline_text", last_year: 42, pivot_year: 42, region: "some region"}

      assert {:ok, %RecentlySeen{} = recently_seen} = Comparison.create_recently_seen(valid_attrs)
      assert recently_seen.first_key == "some first_key"
      assert recently_seen.first_timeline_text == "some first_timeline_text"
      assert recently_seen.first_year == 42
      assert recently_seen.last_key == "some last_key"
      assert recently_seen.last_timeline_text == "some last_timeline_text"
      assert recently_seen.last_year == 42
      assert recently_seen.pivot_year == 42
      assert recently_seen.region == "some region"
    end

    test "create_recently_seen/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comparison.create_recently_seen(@invalid_attrs)
    end

    test "update_recently_seen/2 with valid data updates the recently_seen" do
      recently_seen = recently_seen_fixture()
      update_attrs = %{first_key: "some updated first_key", first_timeline_text: "some updated first_timeline_text", first_year: 43, last_key: "some updated last_key", last_timeline_text: "some updated last_timeline_text", last_year: 43, pivot_year: 43, region: "some updated region"}

      assert {:ok, %RecentlySeen{} = recently_seen} = Comparison.update_recently_seen(recently_seen, update_attrs)
      assert recently_seen.first_key == "some updated first_key"
      assert recently_seen.first_timeline_text == "some updated first_timeline_text"
      assert recently_seen.first_year == 43
      assert recently_seen.last_key == "some updated last_key"
      assert recently_seen.last_timeline_text == "some updated last_timeline_text"
      assert recently_seen.last_year == 43
      assert recently_seen.pivot_year == 43
      assert recently_seen.region == "some updated region"
    end

    test "update_recently_seen/2 with invalid data returns error changeset" do
      recently_seen = recently_seen_fixture()
      assert {:error, %Ecto.Changeset{}} = Comparison.update_recently_seen(recently_seen, @invalid_attrs)
      assert recently_seen == Comparison.get_recently_seen!(recently_seen.id)
    end

    test "delete_recently_seen/1 deletes the recently_seen" do
      recently_seen = recently_seen_fixture()
      assert {:ok, %RecentlySeen{}} = Comparison.delete_recently_seen(recently_seen)
      assert_raise Ecto.NoResultsError, fn -> Comparison.get_recently_seen!(recently_seen.id) end
    end

    test "change_recently_seen/1 returns a recently_seen changeset" do
      recently_seen = recently_seen_fixture()
      assert %Ecto.Changeset{} = Comparison.change_recently_seen(recently_seen)
    end
  end
end
