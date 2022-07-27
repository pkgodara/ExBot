defmodule ExBot.CoinGecko.Default do
  @moduledoc """
  CoinGecko API implimentation
  """

  require Logger

  alias ExBot.CoinGecko.Coin
  alias ExBot.Http.API, as: HTTPAdapter

  @behaviour ExBot.CoinGecko.API

  @max_coins 5

  def search(query) do
    query
    |> search_endpoint()
    |> call_get()
  end

  def prices(id, date) do
    id
    |> history_endpoint(date)
    |> call_get()
  end

  #### Private FNs

  defp call_get(endpoint) do
    case HTTPAdapter.get(endpoint) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body) |> parse_response()}

      {:error, error} ->
        Logger.error("Error fetching data, #{inspect(error)}")
        {:error, error}
    end
  end

  defp parse_response(%{"coins" => coins}) do
    coins = coins |> Enum.take(@max_coins) |> Enum.map(&Coin.parse/1)

    %{coins: coins}
  end

  defp parse_response(%{"id" => id, "market_data" => %{"current_price" => %{"usd" => usd_price}}}) do
    %{
      id: id,
      price: usd_price
    }
  end

  defp parse_response(%{"id" => id}) do
    %{id: id, price: nil}
  end

  defp search_endpoint(query) do
    config = Application.get_env(:ex_bot, :coingecko)

    %{
      base_url: base_url,
      version: version,
      search_api: search_api
    } = config

    Path.join([base_url, version, search_api, "?query=#{query}"])
  end

  defp history_endpoint(coin_id, date) do
    config = Application.get_env(:ex_bot, :coingecko)

    %{
      base_url: base_url,
      version: version
    } = config

    history_api = "coins/#{coin_id}/history"

    Path.join([base_url, version, history_api, "?date=#{date}"])
  end
end
