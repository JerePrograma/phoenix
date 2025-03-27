defmodule PreneurChallenge.Threads.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field :content, :string
    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
