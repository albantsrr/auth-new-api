defmodule AuthTutorialPhoenix.Guardian.AuthPipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
  otp_app: :auth_tutorial_phoenix,
  module: AuthTutorialPhoenix.Guardian,
  error_handler: AuthTutorialPhoenix.GuardianAuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)

end
