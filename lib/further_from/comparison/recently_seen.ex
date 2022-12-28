defmodule FurtherFrom.Comparison.RecentlySeen do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read]
  end

  attributes do
    uuid_primary_key :id

    create_timestamp :inserted_at

    attribute :region, :string do
      default System.get_env("FLY_REGION") || "local"
    end

    attribute :first_key, :string do
      allow_nil? false
    end

    attribute :last_key, :string do
      allow_nil? false
    end

    attribute :first_timeline_text, :string do
      allow_nil? false
    end

    attribute :last_timeline_text, :string do
      allow_nil? false
    end

    attribute :first_year, :integer do
      allow_nil? false
    end

    attribute :last_year, :integer do
      allow_nil? false
    end

    attribute :pivot_year, :integer do
      allow_nil? false
    end
  end
end
