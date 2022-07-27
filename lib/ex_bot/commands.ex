defmodule ExBot.Commands do
  @moduledoc """
  Handle Message commands and return responses to revert
  """

  alias ExBot.CoinGecko.API, as: Coingecko
  alias ExBot.FB.API, as: Facebook
  alias ExBot.Message
  alias ExBot.Templates

  def execute(msg, cmd, params \\ [])

  def execute(%Message{sender_id: sender_id} = _message, "hi", _params) do
    {:ok, %{"first_name" => first_name}} = Facebook.get_profile(sender_id)
    text = EEx.eval_string(Templates.greet(), name: first_name)

    Templates.text_response(sender_id, text)
  end

  def execute(%Message{sender_id: sender_id} = _message, "help", _params) do
    Templates.text_response(sender_id, Templates.help())
  end

  def execute(%Message{} = message, "list", params) do
    with query <- Enum.join(params, " "),
         {:ok, response} <- Coingecko.search(query),
         coins <- parse_coin_list(response) do
      if length(coins) > 0 do
        Templates.generic_template_response(message.sender_id, coins)
      else
        Templates.text_response(message.sender_id, Templates.not_found())
      end
    end
  end

  def execute(%Message{} = message, "prices", params) do
    [currency | _] = params

    today = Date.utc_today()

    prices =
      1..14
      |> Enum.map(fn x -> Date.add(today, -x) end)
      |> Enum.map(fn dt -> "#{dt.day}-#{dt.month}-#{dt.year}" end)
      |> Enum.map(fn dt -> get_price_async(currency, dt) end)
      |> Enum.map(&get_task_await/1)

    Templates.text_response(message.sender_id, Templates.list_prices(prices))
  end

  def execute(message, _, _) do
    Templates.text_response(message.sender_id, Templates.unknown_cmd())
  end

  #### Private functions

  defp parse_coin_list(%{coins: coins}) do
    Enum.map(coins, fn %{name: name, id: id} ->
      %{title: name, payload: "prices #{id}"}
    end)
  end

  defp get_price_async(currency, dt) do
    Task.async(fn ->
      case Coingecko.prices(currency, dt) do
        {:ok, price} -> Map.put(price, :date, dt)
        _ -> %{price: nil, date: dt}
      end
    end)
  end

  defp get_task_await(t), do: Task.await(t, 10_000)
end
