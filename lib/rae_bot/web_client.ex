defmodule RaeBot.WebClient do
  use Tesla

  require Logger

  defp host, do: ExGram.Config.get(:rae_bot, :rae_api_host, "localhost")
  defp port, do: ExGram.Config.get(:rae_bot, :rae_api_port, "4000")

  plug(Tesla.Middleware.BaseUrl, "http://#{host()}:#{port()}")
  plug(Tesla.Middleware.Headers, [{"Content-Type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  def search(word) do
    case get("/api/#{word}") do
      {:ok, %{body: body, status: 200}} ->
        decoded_body = Jason.decode!(body)
        Logger.debug("[GET] /api/#{word} - Response: #{inspect(decoded_body)}")
        {:ok, decoded_body}

      {:ok, %{status: 404}} ->
        {:ok, word, :word_not_found}

      err ->
        Logger.error("Error while searching for #{word}")
        err
    end
  end

  def api_status() do
    case get("/healthz") do
      {:ok, %{status: 200}} -> :api_up
      _ -> :api_down
    end
  end
end
