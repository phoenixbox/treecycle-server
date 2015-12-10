class HomeController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:hello]
  def hello
    render json: {merry: 'christmas'}
  end
end
