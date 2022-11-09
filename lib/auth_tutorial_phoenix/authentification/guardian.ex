defmodule AuthTutorialPhoenix.Guardian do
  use Guardian, otp_app: :auth_tutorial_phoenix
  alias AuthTutorialPhoenix.Accounts

  def subject_for_token(resource, _claim)do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims)do
    id = claims["sub"]
    resource = Accounts.get_by_id!(id)
    {:ok, resource}
  end
end
