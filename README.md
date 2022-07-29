# ExBot

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Setup

1. Create an account on `developers.facebook.com`
2. Create an App for the Bot
3. Add Messenger as product
4. Create & Attach a facebook page to the above app
5. Go to Messenger settings
6. Use `Generate token`, this is your `FB_PAGE_ACCESS_TOKEN`
7. Subscribe to `messages` and `messaging_postbacks` webhooks for the Page
8. Add Callback webhook, in the format `https://example.com/api/facebook_webhook`
9. Ready to interact.

If you're on local, you can use `ngrok http 4000` for forward your requests.

## Interact?

### Greet
1. Send `hi` to the Bot on Messenger.
2. Send `list <query>` to search for top 5 coins matching `query`.
   Example - Send `list usd` to search all coins matching with `usd`
3. Click on any of the coin presented to fetch last 14 days prices for it.


## Docker deployment
### Build
```
docker build ./ -t ex_bot
```
### Run
```
docker run -it -e SECRET_KEY_BASE='<Your Base Here>' -e FB_PAGE_ACCESS_TOKEN='<Your PAT Here>' -p 4000:4000 ex_bot
```
