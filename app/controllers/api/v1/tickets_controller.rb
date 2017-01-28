module Api
  module V1
    class TicketsController < BaseController
      def index
        render json: policy_scope(Ticket)
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

      private

      def ticket_params
        params.require(:ticket).permit(:title, :description)
      end
    end
  end
end
