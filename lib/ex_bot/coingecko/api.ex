defmodule ExBot.CoinGecko.API do
  @moduledoc """
  CoinGecko API behaviour
  """

  ##
  ## https://www.coingecko.com/en/api/documentation
  ##
  ##

  @callback search(query :: String.t()) :: {:ok, any()} | {:error, any()}
  @callback prices(coin_id :: String.t(), date :: String.t()) :: {:ok, any()} | {:error, any()}

  ## Proxies
  def search(query), do: impl().search(query)
  def prices(coin_id, date), do: impl().prices(coin_id, date)

  defp impl, do: Application.get_env(:ex_bot, :coingecko_api_impl, ExBot.CoinGecko.Default)
end
