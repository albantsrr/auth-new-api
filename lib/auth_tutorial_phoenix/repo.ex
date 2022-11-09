defmodule AuthTutorialPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :auth_tutorial_phoenix,
    adapter: Ecto.Adapters.Postgres
end
