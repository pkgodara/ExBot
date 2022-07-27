defmodule ExBot.MessageTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExBot.Message

  import ExBot.Support.Factory

  describe "parse/1" do
    test "successfully parse message event" do
      %{
        id: id,
        mid: mid,
        text: text,
        recipient_id: recipient_id,
        sender_id: sender_id,
        timestamp: timestamp
      } = build(:message)

      text_lower = text |> String.downcase() |> String.trim()

      event = %{
        "id" => id,
        "messaging" => [
          %{
            "message" => %{"mid" => mid, "text" => text},
            "recipient" => %{"id" => recipient_id},
            "sender" => %{"id" => sender_id},
            "timestamp" => timestamp
          }
        ]
      }

      assert %Message{
               id: ^id,
               mid: ^mid,
               text: ^text_lower,
               recipient_id: ^recipient_id,
               sender_id: ^sender_id,
               timestamp: ^timestamp
             } = Message.parse(event)
    end

    test "successfully parse payload event" do
      %{
        id: id,
        mid: mid,
        text: text,
        recipient_id: recipient_id,
        sender_id: sender_id,
        timestamp: timestamp
      } = build(:message)

      text_lower = text |> String.downcase() |> String.trim()

      event = %{
        "id" => id,
        "messaging" => [
          %{
            "postback" => %{"mid" => mid, "payload" => text},
            "recipient" => %{"id" => recipient_id},
            "sender" => %{"id" => sender_id},
            "timestamp" => timestamp
          }
        ]
      }

      assert %Message{
               id: ^id,
               mid: ^mid,
               text: ^text_lower,
               recipient_id: ^recipient_id,
               sender_id: ^sender_id,
               timestamp: ^timestamp
             } = Message.parse(event)
    end
  end
end
