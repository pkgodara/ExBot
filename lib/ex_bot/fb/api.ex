defmodule ExBot.FB.API do
  @moduledoc """
  Facebook API behaviour
  """

  @callback post_message(message :: map()) :: {:ok, any()} | {:error, any()}
  @callback get_profile(customer_id :: String.t()) :: {:ok, any()} | {:error, any()}

  ## Proxies
  def post_message(message), do: impl().post_message(message)
  def get_profile(customer_id), do: impl().get_profile(customer_id)

  defp impl, do: Application.get_env(:ex_bot, :fb_api_impl, ExBot.FB.Default)
end
