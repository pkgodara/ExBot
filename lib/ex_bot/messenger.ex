defmodule ExBot.Messenger do
  @moduledoc """
  Messenger to process Event
  """

  require Logger

  alias ExBot.Commands
  alias ExBot.Message
  alias ExBot.FB.API, as: Facebook

  ##
  ## https://developers.facebook.com/docs/messenger-platform/getting-started/quick-start
  ##

  def handle_event(event) do
    event
    |> Message.parse()
    |> process_event()
  end

  ####   Private FNs

  defp process_event(%Message{sender_id: sender_id, text: text} = message)
       when not is_nil(sender_id) and not is_nil(text) do
    [cmd | params] = String.split(message.text)

    message
    |> Commands.execute(cmd, params)
    |> send_message()
  end

  defp process_event({:error, reason}) do
    Logger.error("error processing event - #{inspect(reason)}")
    {:error, reason}
  end

  defp send_message(message) do
    with {:ok, _response} <- Facebook.post_message(message) do
      # IO.inspect(response)
      :ok
    end
  end
end
