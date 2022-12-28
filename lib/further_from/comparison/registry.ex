defmodule FurtherFrom.Comparison.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry FurtherFrom.Comparison.RecentlySeen
  end
end
