defmodule ExBot.CoinGecko.CoinTest do
  @moduledoc false
  use ExUnit.Case

  alias ExBot.CoinGecko.Coin

  describe "parse/1" do
    test "build struct" do
      id = "tether"
      name = "Tether Coin"
      symbol = "USDT"

      assert %Coin{id: ^id, name: ^name, symbol: ^symbol} =
               Coin.parse(%{"id" => id, "name" => name, "symbol" => symbol})
    end
  end
end
