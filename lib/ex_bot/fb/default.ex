defmodule ExBot.FB.Default do
  @moduledoc """
  Facebook interface implementation
  """

  require Logger

  alias ExBot.Http.API, as: HTTPAdapter

  @behaviour ExBot.FB.API

  def post_message(message) do
    endpoint = send_endpoint()

    case post_json(endpoint, message) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, error} ->
        Logger.error("Error in sending message to bot, #{inspect(error)}")
        {:error, error}
    end
  end

  def get_profile(customer_id) do
    profile_path = profile_endpoint(customer_id)

    case HTTPAdapter.get(profile_path) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, error} ->
        Logger.error("Error fetching profile, #{inspect(error)}")
        {:error, error}
    end
  end

  ####   Private FNs

  defp send_endpoint() do
    config = Application.get_env(:ex_bot, :fb)

    %{
      base_url: base_url,
      version: version,
      send_api: send_api,
      page_access_token: token
    } = config

    token_path = "?access_token=#{token}"

    Path.join([base_url, version, send_api, token_path])
  end

  defp profile_endpoint(sender_id) do
    config = Application.get_env(:ex_bot, :fb)

    %{
      base_url: base_url,
      version: version,
      page_access_token: token
    } = config

    token_path = "?access_token=#{token}"

    Path.join([base_url, version, sender_id, token_path])
  end

  defp post_json(endpoint, message) do
    headers = [{"Content-type", "application/json"}]

    with {:ok, json_msg} <- Jason.encode(message) do
      HTTPAdapter.post(endpoint, json_msg, headers)
    end
  end
end
