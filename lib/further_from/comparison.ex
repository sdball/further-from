defmodule FurtherFrom.Comparison do
  defstruct [:pivot_year, :first, :last, :difference]

  use Ash.Api

  resources do
    # This defines the set of resources that can be used with this API
    registry FurtherFrom.Comparison.Registry
  end
end
