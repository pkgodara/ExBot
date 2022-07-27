defmodule ExBot.TemplatesTest do
  @moduledoc false
  use ExUnit.Case, async: false

  alias ExBot.Templates

  describe "render template" do
    test "greet" do
      name = "John"

      greeting = """
      Hi #{name}! Welcome!
      """

      assert greeting == EEx.eval_string(Templates.greet(), name: name)
    end

    test "help" do
      msg = """
      Start with `hi`.
      --
      You can search coins by name or ID.
      Ex - list usd
      --
      Select a coin to get prices for the last 14 days.
      """

      assert msg == Templates.help()
    end

    test "unknown_cmd" do
      msg = """
      Sorry, I'm still learning. Don't know how to respond to this.
      Try `help` to see what I can do.
      """

      assert msg == Templates.unknown_cmd()
    end

    test "not_found" do
      msg = """
      Oh! Couldn't find anything for that.
      """

      assert msg == Templates.not_found()
    end
  end

  describe "list_prices/1" do
    test "empty list" do
      msg = Templates.not_found()
      assert msg == Templates.list_prices([])
    end

    test "render list" do
      prices = [%{id: "t1", date: "25", price: 1.1}, %{id: "t2", date: "24", price: 2.2}]

      msg = """
      Last 2 days prices for 't1'
      ---
      25 => 1.1 USD

      24 => 2.2 USD
      """

      assert msg == Templates.list_prices(prices)
    end
  end

  describe "text_response/2" do
    test "render text msg" do
      sender = "sender-id"
      text = "response text"

      msg = %{
        "messaging_type" => "RESPONSE",
        "recipient" => %{
          "id" => sender
        },
        "message" => %{"text" => text}
      }

      assert ^msg = Templates.text_response(sender, text)
    end
  end

  describe "generic_template_response/2" do
    test "render without data" do
      sender = "sender-id"

      msg = %{
        "message" => %{
          "attachment" => %{
            "payload" => %{"elements" => [], "template_type" => "generic"},
            "type" => "template"
          }
        },
        "messaging_type" => "RESPONSE",
        "recipient" => %{"id" => sender}
      }

      assert ^msg = Templates.generic_template_response(sender, [])
    end

    test "render data" do
      sender = "sender-id"

      buttons = [
        %{title: "tether", payload: "prices tether"},
        %{title: "t1", payload: "p1"},
        %{title: "t2", payload: "p2"},
        %{title: "t3", payload: "p3"}
      ]

      msg = %{
        "message" => %{
          "attachment" => %{
            "payload" => %{
              "elements" => [
                %{
                  "buttons" => [
                    %{"payload" => "prices tether", "title" => "tether", "type" => "postback"},
                    %{"payload" => "p1", "title" => "t1", "type" => "postback"},
                    %{"payload" => "p2", "title" => "t2", "type" => "postback"}
                  ],
                  "subtitle" => "Click to get prices",
                  "title" => "Top 1-3 search"
                },
                %{
                  "buttons" => [%{"payload" => "p3", "title" => "t3", "type" => "postback"}],
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
        "recipient" => %{"id" => sender}
      }

      assert ^msg = Templates.generic_template_response(sender, buttons)
    end
  end
end
