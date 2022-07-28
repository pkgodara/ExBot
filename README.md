# ExBot

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## Docker deployment
### Build
```
docker build ./ -t ex_bot
```
### Run
```
docker run -it -e SECRET_KEY_BASE='<Your Base Here>' -e FB_PAGE_ACCESS_TOKEN='<Your PAT Here>' -p 4000:4000 ex_bot
```
