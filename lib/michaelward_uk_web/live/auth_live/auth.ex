defmodule MichaelwardUkWeb.Live.Auth do
  @moduledoc """
  LiveView for registering and authenticating users.
  """
  use MichaelwardUkWeb, :live_view
  require Logger
  alias MichaelwardUk.Accounts
  alias MichaelwardUk.Authentication

  def mount(_params, _session, socket) do
    Logger.debug("Auth LiveView mounted")

    {
      :ok,
      socket
      |> assign(:page_title, "Authentication")
    }
  end

  def handle_info({:webauthn_supported, false}, socket) do
    Logger.debug("WebAuthn not supported")

    {
      :noreply,
      socket
      |> put_flash(:error, "This browser does not support passwordless accounts.")
    }
  end

  def handle_info({:webauthn_supported, _true}, socket) do
    Logger.debug("WebAuthn supported")
    {:noreply, socket}
  end

  def handle_info({:user_token, token: nil}, socket) do
    Logger.debug("User token not found")
    {:noreply, socket}
  end

  def handle_info({:find_user_by_username, username: username}, socket) do
    Logger.debug("Finding user by username: #{username}")
    user = Accounts.get_user_by(:username, username, [:keys])

    if user do
      Logger.debug("User found")
      send_update(WebAuthnLiveComponent, id: "auth_form", found_user: user)
      {:noreply, socket}
    else
      Logger.debug("User not found")

      {
        :noreply,
        socket
        |> clear_flash()
        |> put_flash(:error, "There is no user with this username.")
      }
    end
  end

  def handle_info({:register_user, user: user, key: key}, socket) do
    Logger.debug("Registering user")

    with {:ok, %{user: new_user}} <- Accounts.create_user_with_key(user, key),
         session_token <- Authentication.generate_user_session_token(new_user),
         token_64 <- Base.url_encode64(session_token, padding: false) do
      Logger.debug("User registered")

      {
        :noreply,
        socket
        |> clear_flash()
        |> put_flash(:info, "New account for #{new_user.username} registered!")
        |> assign(:current_user, new_user)
        |> push_event("store_token", %{token: token_64})
      }
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.debug("User not registered")

        {
          :noreply,
          socket
          |> send_update(WebAuthnLiveComponent, changeset: changeset)
          |> put_flash(:error, "Failed to register a new account.")
        }

      other_error ->
        Logger.warn(unhandled_error: {__MODULE__, other_error})

        {
          :noreply,
          socket
          |> put_flash(:error, "Failed to register a new account.")
        }
    end
  end

  def handle_info({:authentication_successful, key_id: key_id}, socket) do
    Logger.debug("Authentication successful")
    user_key = Authentication.get_user_key_by_key_id(key_id, [:user])
    %{user: user} = user_key
    session_token = Authentication.generate_user_session_token(user)
    token = Base.url_encode64(session_token, padding: false)
    Authentication.update_user_key(user_key, %{last_used: DateTime.utc_now()})

    {
      :noreply,
      socket
      |> assign(:current_user, user)
      |> push_event("store_token", %{token: token})
      |> clear_flash()
      |> put_flash(:info, "Welcome back, #{user.username}!")
    }
  end

  def handle_info({:error, error}, socket) do
    Logger.error(error: {__MODULE__, error})
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    Logger.debug(unhandled_message: {__MODULE__, message})
    {:noreply, socket}
  end

  def handle_event("sign_out", _value, socket) do
    Logger.debug("Signing out")

    {
      :noreply,
      socket
      |> assign(:current_user, nil)
      |> clear_flash()
      |> put_flash(:info, "You have been signed out.")
    }
  end
end
