defmodule MichaelwardUk.AuthenticationTest do
  use MichaelwardUk.DataCase

  alias MichaelwardUk.Authentication

  describe "user_keys" do
    alias MichaelwardUk.Authentication.UserKey

    import MichaelwardUk.AuthenticationFixtures

    @invalid_attrs %{key_id: nil, label: nil, last_used: nil, public_key: nil}

    test "list_user_keys/0 returns all user_keys" do
      user_key = user_key_fixture()
      assert Authentication.list_user_keys() == [user_key]
    end

    test "get_user_key!/1 returns the user_key with given id" do
      user_key = user_key_fixture()
      assert Authentication.get_user_key!(user_key.id) == user_key
    end

    test "create_user_key/1 with valid data creates a user_key" do
      valid_attrs = %{key_id: "some key_id", label: "some label", last_used: ~U[2022-11-06 21:22:00Z], public_key: "some public_key"}

      assert {:ok, %UserKey{} = user_key} = Authentication.create_user_key(valid_attrs)
      assert user_key.key_id == "some key_id"
      assert user_key.label == "some label"
      assert user_key.last_used == ~U[2022-11-06 21:22:00Z]
      assert user_key.public_key == "some public_key"
    end

    test "create_user_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user_key(@invalid_attrs)
    end

    test "update_user_key/2 with valid data updates the user_key" do
      user_key = user_key_fixture()
      update_attrs = %{key_id: "some updated key_id", label: "some updated label", last_used: ~U[2022-11-07 21:22:00Z], public_key: "some updated public_key"}

      assert {:ok, %UserKey{} = user_key} = Authentication.update_user_key(user_key, update_attrs)
      assert user_key.key_id == "some updated key_id"
      assert user_key.label == "some updated label"
      assert user_key.last_used == ~U[2022-11-07 21:22:00Z]
      assert user_key.public_key == "some updated public_key"
    end

    test "update_user_key/2 with invalid data returns error changeset" do
      user_key = user_key_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_user_key(user_key, @invalid_attrs)
      assert user_key == Authentication.get_user_key!(user_key.id)
    end

    test "delete_user_key/1 deletes the user_key" do
      user_key = user_key_fixture()
      assert {:ok, %UserKey{}} = Authentication.delete_user_key(user_key)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_user_key!(user_key.id) end
    end

    test "change_user_key/1 returns a user_key changeset" do
      user_key = user_key_fixture()
      assert %Ecto.Changeset{} = Authentication.change_user_key(user_key)
    end
  end

  describe "user_tokens" do
    alias MichaelwardUk.Authentication.UserToken

    import MichaelwardUk.AuthenticationFixtures

    @invalid_attrs %{context: nil, token: nil}

    test "list_user_tokens/0 returns all user_tokens" do
      user_token = user_token_fixture()
      assert Authentication.list_user_tokens() == [user_token]
    end

    test "get_user_token!/1 returns the user_token with given id" do
      user_token = user_token_fixture()
      assert Authentication.get_user_token!(user_token.id) == user_token
    end

    test "create_user_token/1 with valid data creates a user_token" do
      valid_attrs = %{context: "some context", token: "some token"}

      assert {:ok, %UserToken{} = user_token} = Authentication.create_user_token(valid_attrs)
      assert user_token.context == "some context"
      assert user_token.token == "some token"
    end

    test "create_user_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user_token(@invalid_attrs)
    end

    test "update_user_token/2 with valid data updates the user_token" do
      user_token = user_token_fixture()
      update_attrs = %{context: "some updated context", token: "some updated token"}

      assert {:ok, %UserToken{} = user_token} = Authentication.update_user_token(user_token, update_attrs)
      assert user_token.context == "some updated context"
      assert user_token.token == "some updated token"
    end

    test "update_user_token/2 with invalid data returns error changeset" do
      user_token = user_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_user_token(user_token, @invalid_attrs)
      assert user_token == Authentication.get_user_token!(user_token.id)
    end

    test "delete_user_token/1 deletes the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{}} = Authentication.delete_user_token(user_token)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_user_token!(user_token.id) end
    end

    test "change_user_token/1 returns a user_token changeset" do
      user_token = user_token_fixture()
      assert %Ecto.Changeset{} = Authentication.change_user_token(user_token)
    end
  end
end
