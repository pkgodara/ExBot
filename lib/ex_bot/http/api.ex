defmodule ExBot.Http.API do
  @moduledoc """
  HTTP API interface
  """

  @callback get(api :: String.t()) :: {:ok, any()} | {:error, any()}
  @callback post(api :: String.t(), payload :: any(), options :: any()) ::
              {:ok, any()} | {:error, any()}

  def get(api), do: impl().get(api)
  def post(api, payload, options), do: impl().post(api, payload, options)

  defp impl, do: Application.get_env(:ex_bot, :http_adapter, HTTPoison)
end
