defmodule MichaelwardUk.Repo.Migrations.CreateUserKeys do
  use Ecto.Migration

  def change do
    create table(:user_keys, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :key_id, :binary
      add :label, :string
      add :last_used, :utc_datetime
      add :public_key, :binary
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:user_keys, [:user_id])
  end
end
