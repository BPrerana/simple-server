class Api::Current::PingsController < APIController
  skip_before_action :authenticate, only: [:show]
  skip_before_action :validate_facility, only: [:show]
  skip_before_action :validate_current_facility_belongs_to_users_facility_group, only: [:show]

  def show
    render json: { status: 'ok' }, status: :ok
  end
end
