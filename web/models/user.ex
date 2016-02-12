defmodule Rumbl.User do
  use Rumbl.Web, :model
  @required_params ~w(name username)
  @optional_params ~w()

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_params, @optional_params)
    |> validate_length(:username, min: 1, max: 20)
  end
end
