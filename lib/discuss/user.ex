defmodule Discuss.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  # \\代表default?
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :provider, :token])
    |> validate_required([:title, :provider, :token])
  end
end
