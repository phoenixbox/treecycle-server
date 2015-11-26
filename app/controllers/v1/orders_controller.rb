require 'securerandom'

module V1
  class OrdersController < ApplicationController

    # Get all the orders for a user
    # @params /v1/users/user_id/orders
    # @return orders: []
    def index
      user = User.find_by_id(params[:user_id])

      if user
        @orders = user.orders
        render json: @orders, each_serializer: V1::OrderSerializer, root: nil
      else
        errors = {
          :errors => {
            :id => SecureRandom.uuid,
            :title => 'Record not found',
            :meta => {
              id: params[:user_id],
              resource: 'User'
            }
          }
        }

        render json: errors, status: :unprocessable_entity
      end
    end

    def update
      @order = Order.find(params[:id])

      if @order.update!(order_params)
        redirect_to v1_order_path(@order)
      else
        render json: { error: t('Order_update_error') }, status: :unprocessable_entity
      end
    end

    def show
      @order = Order.find(params[:id])

      if @order
        render json: @order, serializer: V1::OrderSerializer, root: nil
      else
        render json: { error: t('Order_show_error') }, status: :unprocessable_entity
      end
    end

    def create
      user = User.find_by_id(params[:user_id])

      if user
        invalid_orders = user.orders.by_status(:incomplete)

        if invalid_orders
          errors = invalid_order_errors(invalid_orders)
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
        errors = {:errors => {:id => 'user', :title => 'not found'}}
        render json: errors, status: :unprocessable_entity
      end
    end

    private

    def order_params
      params.require(:order).permit(:uuid, :status_cd, :amount, :address_id, :phone_id, :currency, :charge_id, :description, :paid, :user_id, :pickup_dates)
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
