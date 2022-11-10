defmodule AuthTutorialPhoenix.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias AuthTutorialPhoenix.Repo

  alias AuthTutorialPhoenix.Accounts.User

  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_by_email(email) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_by_id!(id) do
    User |> Repo.get!(id)
  end

  def authenticate_user(email, password) do
    with {:ok, user} <- get_by_email(email) do
      case validate_password(password, user.password) do
        false -> {:error, :unauthorized}
        true -> {:ok, user}
      end
    end
  end

  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end

  # just added

  def list_users do
    Repo.all(User)
  end

  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

  def get_user_by_first_name!(first_name), do: Repo.get_by!(User, first_name: first_name)

  def get_user_by_email_and_first_name!(email, first_name),
    do: Repo.get_by!(User, email: email, first_name: first_name)

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

end
