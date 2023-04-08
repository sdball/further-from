# FurtherFrom

This is the Phoenix LiveView web application and data behind https://furtherfrom.com.

To run the server locally:

  * Have Elixir
  * Have SQlite
  * Clone this repo
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The codebase includes all of the event data directly. Your locally running
instance will have exactly the same data as one of the clustered instances
actually running on furtherfrom.com.
