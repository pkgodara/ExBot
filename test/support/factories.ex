defmodule ExBot.Support.Factory do
  @moduledoc false
  use ExMachina

  alias ExBot.Message

  def message_factory(attrs) do
    message = %Message{
      id: "1234567890",
      mid: "m_ycf57J9yaE6_BVND3YUmi2TYmnRA",
      text: "Hi There",
      recipient_id: "1234567890",
      sender_id: "789012345611111",
      timestamp: 1_658_851_237_494
    }

    merge_attributes(message, attrs)
  end
end
