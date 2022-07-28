defmodule ExBot.Message do
  @moduledoc """
  Message Structure and parsing functions
  """

  @enforce_keys [:id, :mid, :text, :sender_id, :recipient_id, :timestamp]
  defstruct [:id, :mid, :text, :sender_id, :recipient_id, :timestamp]

  def parse(%{
        "id" => id,
        "messaging" => [
          %{
            "message" => %{"mid" => mid, "text" => text},
            "recipient" => %{"id" => recipient_id},
            "sender" => %{"id" => sender_id},
            "timestamp" => timestamp
          }
        ]
      })
      when not is_nil(text) do
    %__MODULE__{
      id: id,
      mid: mid,
      text: text |> String.downcase() |> String.trim(),
      recipient_id: recipient_id,
      sender_id: sender_id,
      timestamp: timestamp
    }
  end

  def parse(%{
        "id" => id,
        "messaging" => [
          %{
            "postback" => %{"mid" => mid, "payload" => text},
            "recipient" => %{"id" => recipient_id},
            "sender" => %{"id" => sender_id},
            "timestamp" => timestamp
          }
        ]
      })
      when not is_nil(text) do
    %__MODULE__{
      id: id,
      mid: mid,
      text: text |> String.downcase() |> String.trim(),
      recipient_id: recipient_id,
      sender_id: sender_id,
      timestamp: timestamp
    }
  end

  def parse(_), do: {:error, :invalid_message}
end
