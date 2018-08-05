defmodule RaeBot.Utils do
  def generate_inline_response(responses, parse_mode \\ "") do
    responses
    |> Enum.map(fn [title: title, result: result] ->
      %ExGram.Model.InlineQueryResultArticle{
        input_message_content: %ExGram.Model.InputTextMessageContent{
          message_text: result,
          parse_mode: parse_mode
        },
        title: title,
        id: :rand.uniform(100),
        type: "article"
      }
    end)
  end
end
