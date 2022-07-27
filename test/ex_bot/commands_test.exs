defmodule ExBot.CommandsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExBot.Commands
  alias ExBot.CoinGecko.Coin

  import Mox
  import ExBot.Support.Factory

  setup :verify_on_exit!

  describe "execute/3" do
    test "command - hi" do
      sender_id = "5304724019611519"

      message = build(:message, sender_id: sender_id)

      expect(FbMockAPI, :get_profile, fn ^sender_id ->
        {:ok,
         %{
           "first_name" => "John",
           "id" => sender_id,
           "last_name" => "Doe"
         }}
      end)

      assert %{
               "message" => %{"text" => "Hi John! Welcome!\n"},
               "messaging_type" => "RESPONSE",
               "recipient" => %{"id" => ^sender_id}
             } = Commands.execute(message, "hi", ["any", "other", "data"])
    end

    test "command - help" do
      sender_id = "5304724019611519"

      message = build(:message, sender_id: sender_id)

      assert %{
               "message" => %{
                 "text" => """
                 Start with `hi`.
                 --
                 You can search coins by name or ID.
                 Ex - list usd
                 --
                 Select a coin to get prices for the last 14 days.
                 """
               },
               "messaging_type" => "RESPONSE",
               "recipient" => %{"id" => ^sender_id}
             } = Commands.execute(message, "help", ["any", "other", "data"])
    end

    test "unsupported command" do
      sender_id = "5304724019611519"
      message = build(:message, sender_id: sender_id)

      assert %{
               "message" => %{
                 "text" => """
                 Sorry, I'm still learning. Don't know how to respond to this.
                 Try `help` to see what I can do.
                 """
               },
               "messaging_type" => "RESPONSE",
               "recipient" => %{"id" => ^sender_id}
             } = Commands.execute(message, "xyz", ["any", "other", "data"])
    end

    test "command - list <query>" do
      sender_id = "5304724019611519"
      message = build(:message, sender_id: sender_id)

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

      assert %{
               "message" => %{
                 "attachment" => %{
                   "payload" => %{
                     "elements" => [
                       %{
                         "buttons" => [
                           %{
                             "payload" => "prices tether",
                             "title" => "Tether",
                             "type" => "postback"
                           },
                           %{
                             "payload" => "prices usd-coin",
                             "title" => "USD Coin",
                             "type" => "postback"
                           },
                           %{
                             "payload" => "prices binance-usd",
                             "title" => "Binance USD",
                             "type" => "postback"
                           }
                         ],
                         "subtitle" => "Click to get prices",
                         "title" => "Top 1-3 search"
                       },
                       %{
                         "buttons" => [
                           %{
                             "payload" => "prices true-usd",
                             "title" => "TrueUSD",
                             "type" => "postback"
                           },
                           %{
                             "payload" => "prices compound-usd-coin",
                             "title" => "cUSDC",
                             "type" => "postback"
                           }
                         ],
                         "subtitle" => "Click to get prices",
                         "title" => "Top 4-6 search"
                       }
                     ],
                     "template_type" => "generic"
                   },
                   "type" => "template"
                 }
               },
               "messaging_type" => "RESPONSE",
               "recipient" => %{"id" => ^sender_id}
             } = Commands.execute(message, "list", ["usd"])
    end

    test "command - prices <coin-id>" do
      sender_id = "5304724019611519"
      message = build(:message, sender_id: sender_id)
      price = 1.001980812638723

      expect(CoinGeckoMockAPI, :prices, 14, fn "tether", _date ->
        {:ok,
         %{
           id: "tether",
           price: price
         }}
      end)

      assert %{
               "message" => %{
                 "text" => text
               },
               "messaging_type" => "RESPONSE",
               "recipient" => %{"id" => ^sender_id}
             } = Commands.execute(message, "prices", ["tether"])

      assert text =~ "Last 14 days prices for 'tether'"
      assert text =~ "=> #{price} USD"
    end
  end
end
