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
<img width="986" alt="Screenshot 2022-07-29 at 9 29 52 AM" src="https://user-images.githubusercontent.com/16938349/181693070-996a5396-d7f3-4e3b-9016-e5619f8120bc.png">

7. Subscribe to `messages` and `messaging_postbacks` webhooks for the Page
<img width="986" alt="Screenshot 2022-07-29 at 9 30 23 AM" src="https://user-images.githubusercontent.com/16938349/181693130-87cb717e-2fca-40b0-8e03-a8f70585659d.png">

8. Add Callback webhook, in the format `https://example.com/api/facebook_webhook`
<img width="986" alt="Screenshot 2022-07-29 at 9 30 08 AM" src="https://user-images.githubusercontent.com/16938349/181693163-1648b304-c81f-4400-bd1b-241b99e404eb.png">

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
