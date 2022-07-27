defmodule ExBot.MessengerTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExBot.CoinGecko.Coin
  alias ExBot.Messenger

  import Mox

  setup :verify_on_exit!

  describe "handle_event/1" do
    test "successfully process a message event" do
      sender_id = "5304724019611519"

      event = %{
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

      expect(FbMockAPI, :get_profile, fn ^sender_id ->
        {:ok,
         %{
           "first_name" => "John",
           "id" => "5304724019611519",
           "last_name" => "Doe"
         }}
      end)

      message = %{
        "message" => %{"text" => "Hi John! Welcome!\n"},
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

      assert :ok = Messenger.handle_event(event)
    end

    test "successfully process a message event - list" do
      sender_id = "5304724019611519"

      event = %{
        "id" => "108056681991744",
        "messaging" => [
          %{
            "message" => %{
              "mid" => "m_ycf57J9yaE6_BVND3YUmi2TYmnRA",
              "text" => "list usd"
            },
            "recipient" => %{"id" => "108056681991744"},
            "sender" => %{"id" => sender_id},
            "timestamp" => 1_658_919_250_339
          }
        ]
      }

      expect(FbMockAPI, :get_profile, 0, fn ^sender_id ->
        {:ok, %{}}
      end)

      expect(CoinGeckoMockAPI, :search, fn "usd" ->
        {:ok,
         %{
           coins: [
             %Coin{id: "tether", name: "Tether", symbol: "USDT"},
             %Coin{id: "usd-coin", name: "USD Coin", symbol: "USDC"},
             %Coin{id: "binance-usd", name: "Binance USD", symbol: "BUSD"},
             %Coin{id: "true-usd", name: "TrueUSD", symbol: "TUSD"},
             %Coin{id: "compound-usd-coin", name: "cUSDC", symbol: "CUSDC"}
           ]
         }}
      end)

      expect(FbMockAPI, :post_message, fn %{
                                            "messaging_type" => "RESPONSE",
                                            "recipient" => %{"id" => ^sender_id},
                                            "message" => %{
                                              "attachment" => %{
                                                "type" => "template",
                                                "payload" => %{
                                                  "template_type" => "generic",
                                                  "elements" => [
                                                    %{
                                                      "subtitle" => _,
                                                      "title" => _,
                                                      "buttons" => [
                                                        %{
                                                          "payload" => _,
                                                          "title" => _,
                                                          "type" => _
                                                        }
                                                        | _
                                                      ]
                                                    }
                                                    | _
                                                  ]
                                                }
                                              }
                                            }
                                          } ->
        {:ok,
         %{
           "message_id" => "m_PnwY7ObwnWUp_sFTs1RRNSMx3ew",
           "recipient_id" => sender_id
         }}
      end)

      assert :ok = Messenger.handle_event(event)
    end

    test "successfully process a postback event - prices" do
      sender_id = "5304724019611519"

      event = %{
        "id" => "108056681991744",
        "messaging" => [
          %{
            "postback" => %{
              "mid" => "m_hZDuN0CzOT2rY0dDDQuLFa2CKPrxrW0J9N_b8Q",
              "payload" => "prices tether",
              "title" => "Tether"
            },
            "recipient" => %{"id" => "108056681991744"},
            "sender" => %{"id" => sender_id},
            "timestamp" => 1_658_919_250_339
          }
        ]
      }

      expect(FbMockAPI, :get_profile, 0, fn ^sender_id ->
        {:ok, %{}}
      end)

      expect(CoinGeckoMockAPI, :prices, 14, fn coin_id, _date ->
        {:ok,
         %{
           id: coin_id,
           price: 1.001980812638723
         }}
      end)

      expect(FbMockAPI, :post_message, fn %{
                                            "messaging_type" => "RESPONSE",
                                            "recipient" => %{"id" => ^sender_id},
                                            "message" => %{
                                              "text" => _
                                            }
                                          } ->
        {:ok,
         %{
           "message_id" => "m_PnwY7ObwnWUp_sFTs1RRNSMx3ew",
           "recipient_id" => sender_id
         }}
      end)

      assert :ok = Messenger.handle_event(event)
    end
  end
end
