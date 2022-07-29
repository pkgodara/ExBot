defmodule ExBotWeb.MessengerControllerTest do
  use ExBotWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  describe "verify_token" do
    test "successfully verify token", %{conn: conn} do
      params = %{
        "hub.challenge" => "1619761148",
        "hub.mode" => "subscribe",
        "hub.verify_token" => "https://8800-117-212-22-80.in.ngrok.io/api/facebook_webhook"
      }

      {challenge, ""} = params["hub.challenge"] |> Integer.parse()

      conn = get(conn, Routes.messenger_path(conn, :verify_token, params))
      assert challenge == json_response(conn, 200)
    end

    test "error on invalid challenge", %{conn: conn} do
      params = %{
        "hub.challenge" => "1619xyzz",
        "hub.mode" => "subscribe",
        "hub.verify_token" => "https://8800-117-212-22-80.in.ngrok.io/api/facebook_webhook"
      }

      conn = get(conn, Routes.messenger_path(conn, :verify_token, params))
      assert %{"status" => "error", "message" => "unauthorized"} = json_response(conn, 403)
    end
  end

  describe "handle_message/2" do
    test "successfully process message event", %{conn: conn} do
      sender_id = "5304724019611519"

      params = %{
        "entry" => [
          %{
            "id" => "108056681991744",
            "messaging" => [
              %{
                "message" => %{
                  "mid" => "m_ycf57J9yaE6_BVND3YUmi2TYmnRA",
                  "text" => "hi"
                },
                "recipient" => %{"id" => "108056681991744"},
                "sender" => %{"id" => sender_id},
                "timestamp" => 1_658_851_237_494
              }
            ]
          }
        ]
      }

      expect(FbMockAPI, :get_profile, fn ^sender_id ->
        {:ok,
         %{
           "first_name" => "John",
           "id" => "5304724019611519",
           "last_name" => "Doe"
         }}
      end)

      message = %{
        "message" => %{
          "text" =>
            "Hi John! Welcome!\n--\nSearch coins by name or ID -\nType - list <query>\n\nExmaples -\n1. list usd\n2. list bitcoin\n3. list usd coin\n"
        },
        "messaging_type" => "RESPONSE",
        "recipient" => %{"id" => sender_id}
      }

      expect(FbMockAPI, :post_message, fn ^message ->
        {:ok,
         %{
           "message_id" => "m_PnwY7ObwnWUp_sFTs1RRNSMx3ew",
           "recipient_id" => sender_id
         }}
      end)

      conn = post(conn, Routes.messenger_path(conn, :handle_message), params)
      assert %{"status" => "ok", "message" => "EVENT_RECEIVED"} = json_response(conn, 200)
    end
  end
end
