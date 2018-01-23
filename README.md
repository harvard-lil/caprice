# Caprice

Installation:

  * Install PostgreSQL
  * Install Erlang, Elixir, and Phoenix: `https://hexdocs.pm/phoenix/installation.html`
  * Clone the repo: `git clone git@github.com:harvard-lil/caprice.git && cd caprice`
  * Configure your DB connection in `config/dev.exs` (runs in a dev env by default)
  * start your postgres server
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install && cd ..`
  * Start your Phoenix endpoint in a REPL instance with `iex -S mix phx.server`
  * Ingest included volumes `import Caprice.Ingest; Caprice.Ingest.ingest("assets/cases/")`
  * If you'd like to continue with an instance running outside of the REPL, press `ctrl-c` twice, and then run `mix phx.server` 

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.