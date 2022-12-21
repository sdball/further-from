defmodule FurtherFrom.TimelineTest do
  use FurtherFrom.DataCase

  alias FurtherFrom.Timeline

  describe "events" do
    alias FurtherFrom.Timeline.Event

    import FurtherFrom.TimelineFixtures

    @invalid_attrs %{
      category: nil,
      description: nil,
      key: nil,
      summary_text: nil,
      timeline_text: nil,
      short_name: nil,
      year: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Timeline.list_events() == [event]
    end

    test "get_random_event/0 returns a random event" do
      event1 = event_fixture(key: "event1")
      event2 = event_fixture(key: "event2")
      event3 = event_fixture(key: "event3")
      assert Timeline.get_random_event() in [event1, event2, event3]

      random_keys_count =
        for _ <- 1..10 do
          Timeline.get_random_event().key
        end
        |> Enum.frequencies()
        |> Enum.count()

      assert random_keys_count > 1
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Timeline.get_event!(event.id) == event
    end

    test "get_event_by_key/1 returns the event with given key" do
      event = event_fixture()
      assert Timeline.get_event_by_key(event.key) == event
    end

    test "get_event_by_key/1 returns nil for an invalid key" do
      assert Timeline.get_event_by_key("") == nil
    end

    test "get_event_by_key!/1 returns the event with given key" do
      event = event_fixture()
      assert Timeline.get_event_by_key!(event.key) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        category: "some category",
        description: "some description",
        key: "some key",
        summary_text: "some summary_text",
        timeline_text: "some timeline_text",
        short_name: "some short_name",
        year: 42
      }

      assert {:ok, %Event{} = event} = Timeline.create_event(valid_attrs)
      assert event.category == "some category"
      assert event.description == "some description"
      assert event.key == "some key"
      assert event.summary_text == "some summary_text"
      assert event.timeline_text == "some timeline_text"
      assert event.short_name == "some short_name"
      assert event.year == 42
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        category: "some updated category",
        description: "some updated description",
        key: "some updated key",
        summary_text: "some updated summary_text",
        timeline_text: "some updated timeline_text",
        short_name: "some updated short_name",
        year: 43
      }

      assert {:ok, %Event{} = event} = Timeline.update_event(event, update_attrs)
      assert event.category == "some updated category"
      assert event.description == "some updated description"
      assert event.key == "some updated key"
      assert event.summary_text == "some updated summary_text"
      assert event.timeline_text == "some updated timeline_text"
      assert event.short_name == "some updated short_name"
      assert event.year == 43
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_event(event, @invalid_attrs)
      assert event == Timeline.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Timeline.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Timeline.change_event(event)
    end
  end
end
