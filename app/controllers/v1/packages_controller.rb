module V1
  class PackagesController < ApplicationController

    def destroy
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        order = user.orders.find_by_uuid(params[:order_id])

        if order
          @package = order.packages.find_by_id(params[:id])

          if @package
            order_id = @package.order_id
            if @package.destroy!
              redirect_to v1_user_order_path(user.id , order_id)
            else
              authentication_error
            end
          else
            render json: { error: t('no_package_found') }, status: :unprocessable_entity
          end
        else
          render json: { error: t('no_order_found') }, status: :unprocessable_entity
        end
      else
        authentication_error
      end
    end

    private

    def package_params
      params.require(:package).permit(:id)
    end
  end
end
