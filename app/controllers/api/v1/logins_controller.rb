class Api::V1::LoginsController < Api::V2::LoginsController
  include Api::V1::ApiControllerOverrides

  def user_to_response(user)
    Api::V1::UserTransformer.to_response(user)
  end
end