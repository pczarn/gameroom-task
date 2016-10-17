module Api
  module V1
    User = User

    class UserTokenController < Knock::AuthTokenController
    end
  end
end
