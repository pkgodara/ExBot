defmodule ExBotWeb.MessengerController do
  use ExBotWeb, :controller

  ##
  ## Docs - https://developers.facebook.com/docs/messenger-platform/webhooks
  ##
  ##

  def verify_token(conn, %{"hub.mode" => "subscribe", "hub.challenge" => challenge} = _params) do
    case Integer.parse(challenge) do
      {challenge, ""} ->
        conn
        |> put_status(200)
        |> json(challenge)

      _ ->
        conn
        |> put_status(403)
        |> json(%{status: "error", message: "unauthorized"})
    end
  end

  def handle_message(conn, %{"entry" => [event]} = _params) do
    ExBot.Messenger.handle_event(event)

    # Respond to event received, regardless of feedback
    conn
    |> put_status(200)
    |> json(%{status: "ok", message: "EVENT_RECEIVED"})
  end
end
