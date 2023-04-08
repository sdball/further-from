defmodule FurtherFromWeb.PlausibleTrackerController do
  require Logger
  use FurtherFromWeb, :controller

  def pageview(%Plug.Conn{req_headers: headers} = conn, _params) do
    user_agent =
      headers
      |> Enum.find(&(elem(&1, 0) == "user-agent"))
      |> case do
        nil -> nil
        header -> header |> elem(1)
      end

    remote_ip = conn.remote_ip |> :inet.ntoa() |> to_string

    headers = [
      {"User-Agent", user_agent},
      {"X-Forwarded-For", remote_ip},
      {"Content-Type", "application/json"}
    ]

    with {:ok, body_text, _conn} <- Plug.Conn.read_body(conn),
         {:ok, body} <- Jason.decode(body_text) do
      body = Map.put(body, :props, %{region: System.get_env("FLY_REGION")})

      request =
        Finch.build(
          :post,
          "https://plausible.io/api/event",
          headers,
          body |> Jason.encode_to_iodata!()
        )

      if conn.host == "localhost" do
        Logger.debug(request)
      else
        Finch.request(request, FurtherFrom.Finch)
      end
    else
      error ->
        Logger.error(error)
    end

    text(conn, "OK")
  end
end
