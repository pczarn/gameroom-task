module Api
  module V1
    User = User

    class UserTokenController < Knock::AuthTokenController
      def create
        render json: { knock: JSON.parse(auth_token.to_json), user: UserRepresenter.new(entity) },
               status: :created
      end
    end
  end
end
