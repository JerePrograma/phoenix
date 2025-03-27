defmodule PreneurChallenge.Repo do
  use Ecto.Repo,
    otp_app: :preneur_challenge,
    adapter: Ecto.Adapters.Postgres
end
