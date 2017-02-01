# frozen_string_literal: true
module Api
  module V1
    class CommentsController < BaseController
      def index
        ticket = Ticket.find(params[:ticket_id])
        authorize ticket, :show?
        comments = ticket.comments.order(created_at: :desc).includes(:author).page(params[:page] || 1)
        render json: comments, meta: pagination_dict(comments)
      end

      def create
        ticket = Ticket.find(params[:ticket_id])
        authorize ticket, :show?
        comment = ticket.comments.build(comment_params.merge(author: current_user))
        if comment.save
          render json: comment
        else
          render json: comment.errors.full_messages, status: :not_acceptable
        end
      end

      def destroy
        comment = Comment.find(params[:id])
        authorize comment
        comment.destroy
        render json: comment
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
