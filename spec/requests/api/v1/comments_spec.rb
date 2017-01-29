# frozen_string_literal: true
require 'rails_helper'
require 'shared/authentication_error'

describe 'Comments', type: :request do
  let(:user) { create :user }
  let(:ticket) { create :ticket, author: user }
  let!(:comment) { create :comment, ticket: ticket, author: user }

  describe 'GET /tickets/:id/comments' do
    let(:user2) { create :user }
    let(:ticket2) { create :ticket, author: user2 }
    let!(:comment2) { create :comment, ticket: ticket2, author: user2 }

    context 'as customer user' do
      context 'his own ticket' do
        before { get api_v1_ticket_comments_path(ticket_id: ticket.id), headers: { authorization: jwt_for(user) } }

        it 'returns ticket\'s comments' do
          expect(response.status).to eq 200
          expect(response.body).to eq({
            comments: [comment_hash(comment)],
            meta: { current_page: 1, total_pages: 1, total_count: 1 }
          }.to_json)
        end
      end

      context 'someone else\'s ticket' do
        before do
          get api_v1_ticket_comments_path(ticket_id: ticket2.id), headers: { authorization: jwt_for(user) }
        end

        it_behaves_like 'authentication error'
      end
    end

    %w(support admin).each do |role|
      context "as #{role} user" do
        before { user.public_send("#{role}!") }

        context 'not his ticket' do
          before do
            get api_v1_ticket_comments_path(ticket_id: ticket2.id), headers: { authorization: jwt_for(user) }
          end

          it 'returns ticket\'s comments' do
            expect(response.status).to eq 200
            expect(response.body).to eq({
              comments: [comment_hash(comment2)],
              meta: { current_page: 1, total_pages: 1, total_count: 1 }
            }.to_json)
          end
        end
      end
    end
  end

  describe 'POST /tickets/:id/comments' do
    context 'as customer user' do
      let!(:comments_count) { Comment.count }
      before do
        post api_v1_ticket_comments_path(ticket_id: ticket.id), headers: { authorization: jwt_for(user) },
                                                                params: { comment: { body: 'New comment' } }
      end

      it 'creates new comment' do
        expect(response.status).to eq 200
        expect(response.body).to eq({ comment: comment_hash(Comment.last) }.to_json)
        expect(Comment.count).to eq comments_count + 1
      end
    end
  end

  describe 'DELETE /tickets/:id/comments/:id' do
    context 'as customer user' do
      let!(:comments_count) { Comment.count }
      before do
        delete api_v1_ticket_comment_path(comment, ticket_id: ticket.id),
               headers: { authorization: jwt_for(user) }
      end

      it 'creates new comment' do
        expect(response.status).to eq 200
        expect(Comment.count).to eq comments_count - 1
      end
    end
  end

  def comment_hash(comment)
    {
      id: comment.id,
      body: comment.body,
      author: {
        name: comment.author.name,
        email: comment.author.email
      }
    }
  end
end
