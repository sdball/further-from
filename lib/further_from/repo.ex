defmodule FurtherFrom.Repo do
  use Ecto.Repo,
    otp_app: :further_from,
    adapter: Ecto.Adapters.SQLite3
end
