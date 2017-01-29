# frozen_string_literal: true
module Api
  module V1
    class TicketsController < BaseController
      def index
        tickets = policy_scope(Ticket).page(params[:page] || 1)
        render json: tickets, meta: pagination_dict(tickets)
      end

      def show
        ticket = Ticket.find(params[:id])
        authorize ticket
        render json: ticket
      end

      def create
        authorize Ticket
        ticket = current_user.tickets.build(ticket_params)
        if ticket.save
          render json: ticket
        else
          render json: ticket.errors.full_messages, status: :not_acceptable
        end
      end

      def update
        ticket = Ticket.find(params[:id])
        authorize ticket
        if ticket.update_attributes(ticket_params)
          render json: ticket
        else
          render json: ticket.errors.full_messages, status: :not_acceptable
        end
      end

      def destroy
        ticket = Ticket.find(params[:id])
        authorize ticket
        ticket.destroy
      end

      def change_status
        ticket = Ticket.find(params[:id])
        authorize ticket
        event = ticket.current_state.events.keys.map(&:to_s).find { |e| e == params[:event] }
        ticket.public_send("#{event}!") if event
        render json: ticket
      end

      private

      def ticket_params
        params.require(:ticket).permit(:title, :description)
      end
    end
  end
end
