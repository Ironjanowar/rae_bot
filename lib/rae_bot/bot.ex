defmodule RaeBot.Bot do
  @bot :rae_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  def bot(), do: @bot

  def format_definition_response(word, :word_not_found) do
    "Word #{word} could not be found"
  end

  def format_definition_response(word, definition) do
    "<b>Word:</b> #{word}\n<b>Definition:</b> #{definition}"
  end

  def search(word) do
    case RaeBot.WebClient.search(word) do
      {:ok, [%{"definitions" => [%{"definition" => definition} | _]} | _]} ->
        Logger.info("Searched for word #{word}, definition: #{definition}")
        {:ok, word, definition}

      err ->
        err
    end
  end

  def handle({:command, "start", _msg}, context) do
    context |> inspect |> Logger.debug()
    answer(context, "Hello there!\nThis is a bot to search for words in spanish :D")
  end

  def handle({:command, "search", %{text: msg_text}}, context) do
    msg_text
    |> String.split()
    |> Enum.reduce(context, fn word, cnt ->
      case search(word) do
        {:ok, word, word_data} ->
          Logger.info("Formatting word #{word}")
          text = format_definition_response(word, word_data)
          cnt |> answer(text, parse_mode: "HTML")

        err ->
          err |> inspect |> Logger.error()
          cnt
      end
    end)
  end
end
