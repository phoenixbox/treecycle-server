require 'securerandom'

module V1
  class OrdersController < ApplicationController

    # Get all the orders for a user
    # @params /v1/users/user_id/orders
    # @return orders: []
    def index
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        admin_uid = params[:admin_uid]
        admin_secret = params[:admin_secret]

        if admin_uid && admin_uid == ENV['ADMIN_UID'] && admin_secret == ENV['ADMIN_SECRET']
          @orders = Order.all
        else
          @orders = user.orders
        end

        render json: @orders, each_serializer: V1::OrderSerializer, root: nil
      else
        authentication_error
      end
    end

    # No good reason to have implemented uuids - remove in future
    # params[:id] really means params[:uuid]
    def update
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @order = user.orders.find_by_uuid(params[:id])

        if @order.update!(order_params)
          redirect_to v1_user_order_path(@order.user.id , @order.id)
        else
          render json: { error: t('Order_update_error') }, status: :unprocessable_entity
        end
      else
        authentication_error
      end
    end

    def show
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @order = user.orders.find_by_id(params[:id])

        if @order
          render json: @order, serializer: V1::OrderSerializer, root: nil
        else
          render json: { error: t('Order_show_error') }, status: :unprocessable_entity
        end
      else
        authentication_error
      end
    end

    def create
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @incomplete_orders = user.orders.by_status("incomplete")

        if @incomplete_orders.length > 0
          errors = invalid_order_errors(@incomplete_orders)
          render json: errors, status: :unprocessable_entity
        else
          @order = user.orders.new(order_params)

          if @order.save
            render json: @order, serializer: V1::OrderSerializer, root: nil
          else
            render json: { error: t('order_create_error') }, status: :unprocessable_entity
          end
        end
      else
        authentication_error
      end
    end

    def destroy
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        order = user.orders.find_by_uuid(params[:id])

        if order.destroy!
          redirect_to v1_user_orders_path(user.id)
        else
          render json: { error: t('couldnt_delete_order') }, status: :unprocessable_entity
        end
      else
        authentication_error
      end
    end

    private

    def order_params
      params.require(:order).permit(:admin_uid, :admin_secret, :uuid, :status_cd, :cancelled, :amount, :address_id, :phone_id, :currency, :charge_id, :description, :paid, :user_id, packages_attributes: [:type_cd, :size_value, :size_unit], pickup_dates_attributes: [:id, :date,
 :user_id, :_destroy])
    end

    def invalid_order_errors orders
      orders.map do |error|
        {
          :errors => {
            :id => SecureRandom.uuid,
            :title => 'Cannot create new order when invalid orders are present',
            :meta => {
              id: error.id,
              resource: 'Order'
            }
          }
        }
      end
    end
  end
end
