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

  def search_and_format(word) do
    case search(word) do
      {:ok, word, word_data} ->
        Logger.info("Formatting word #{word}")
        text = format_definition_response(word, word_data)
        {:ok, text}

      err ->
        err |> inspect |> Logger.error()
        {:error, err}
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
      case search_and_format(word) do
        {:ok, text} -> cnt |> answer(text, parse_mode: "HTML")
        _ -> cnt
      end
    end)
  end

  # Inline queries
  def handle({:update, %{inline_query: %{id: inline_query_id, query: word}}}, _context)
      when word != "" do
    Logger.info("Text query: #{word}")

    {:ok, text} = search_and_format(word)
    message_text = %ExGram.Model.InputTextMessageContent{message_text: text}

    result = %ExGram.Model.InlineQueryResultArticle{
      input_message_content: message_text,
      title: "Result 1",
      id: 1,
      type: "article"
    }

    ExGram.answer_inline_query(inline_query_id, [result]) |> inspect |> Logger.debug()
  end
end
