defmodule MichaelwardUk.AuthenticationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MichaelwardUk.Authentication` context.
  """

  @doc """
  Generate a user_key.
  """
  def user_key_fixture(attrs \\ %{}) do
    {:ok, user_key} =
      attrs
      |> Enum.into(%{
        key_id: "some key_id",
        label: "some label",
        last_used: ~U[2022-11-06 21:22:00Z],
        public_key: "some public_key"
      })
      |> MichaelwardUk.Authentication.create_user_key()

    user_key
  end

  @doc """
  Generate a user_token.
  """
  def user_token_fixture(attrs \\ %{}) do
    {:ok, user_token} =
      attrs
      |> Enum.into(%{
        context: "some context",
        token: "some token"
      })
      |> MichaelwardUk.Authentication.create_user_token()

    user_token
  end
end
