defmodule RaeBot do
  use Application

  import Supervisor.Spec

  require Logger

  def start(_type, _args) do
    token = ExGram.Config.get(:rae_bot, :token)

    children = [
      supervisor(ExGram, []),
      supervisor(RaeBot.Bot, [:polling, token])
    ]

    opts = [strategy: :one_for_one, name: RaeBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting RaeBot")
        ok

      error ->
        Logger.error("Error starting RaeBot")
        error
    end
  end
end
