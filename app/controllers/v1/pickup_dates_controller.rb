module V1
  class PickupDatesController < ApplicationController

    def destroy
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        order = Order.find_by_uuid(params[:order_id])
        if order
          @date = order.pickup_dates.find_by_id(params[:id])

          if @date
            order_id = @date.order_id
            if @date.destroy!
              redirect_to v1_user_order_path(user.id , order_id)
            else
              authentication_error
            end
          else
            render json: { error: t('no_pickup_date_found') }, status: :unprocessable_entity
          end
        else
          render json: { error: t('no_order_found') }, status: :unprocessable_entity
        end
      else
        authentication_error
      end
    end

    private

    def pickup_date_params
      params.require(:pickup_date).permit(:id)
    end
  end
end
