defmodule Rumbl.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user    = user_id && repo.get(Rumbl.User, user_id)
    # if no user_id or no such user, assigns nil
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Rumbl.User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        # simulate a password check with variable timing, so that nobody can
        # tell by timing that the user doesn't exist :)
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    # drop the whole session at the end of the request. It would also
    # be possible to just delete the user id from the session
    configure_session(conn, drop: true)
  end
end
