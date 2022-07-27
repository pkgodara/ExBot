defmodule ExBot.FB.DefaultTest do
  @moduledoc false
  use ExUnit.Case

  alias ExBot.FB.Default, as: FbAPI

  import Mox

  setup :verify_on_exit!

  describe "post_message/1" do
    test "post message to FB" do
      sender_id = "1234567890"

      message = %{
        "message" => %{"text" => "Hi John! Welcome!\n"},
        "messaging_type" => "RESPONSE",
        "recipient" => %{"id" => sender_id}
      }

      json_message = Jason.encode!(message)

      body = %{
        "message_id" => "m_PnwY7ObwnWUp_sFTs1RRNSMx3ew",
        "recipient_id" => sender_id
      }

      expect(HttpMock, :post, fn _endpoint, ^json_message, _opts ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: Jason.encode!(body)
         }}
      end)

      assert {:ok, ^body} = FbAPI.post_message(message)
    end
  end

  describe "get_profile/1" do
    test "get profile from FB" do
      sender_id = "1234567890"

      body = %{
        "first_name" => "John",
        "id" => sender_id,
        "last_name" => "Doe"
      }

      expect(HttpMock, :get, fn endpoint ->
        assert endpoint =~ sender_id

        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: Jason.encode!(body)
         }}
      end)

      assert {:ok, ^body} = FbAPI.get_profile(sender_id)
    end
  end
end
