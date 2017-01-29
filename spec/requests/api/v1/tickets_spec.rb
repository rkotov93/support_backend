# frozen_string_literal: true
require 'rails_helper'
require 'shared/authentication_error'

RSpec.shared_examples 'privileged user' do
  it 'returns all tickets' do
    expect(response.status).to eq 200
    expect(response.body).to eq({
      tickets: [ticket_hash(user_ticket), ticket_hash(another_ticket)]
    }.to_json)
  end
end

RSpec.describe 'Tickets', type: :request do
  let(:user) { create :user }
  let!(:user_ticket) { create :ticket, author: user }
  let!(:another_ticket) { create :ticket }

  describe 'GET /tickets' do
    context 'as a customer user' do
      before { get api_v1_tickets_path, headers: { authorization: jwt_for(user) } }

      it 'returns only user\'s tickets' do
        expect(response.status).to eq 200
        expect(response.body).to eq({ tickets: [ticket_hash(user_ticket)] }.to_json)
      end
    end

    %w(support admin).each do |role|
      context "as a #{role} user" do
        before do
          user.public_send("#{role}!")
          get api_v1_tickets_path, headers: { authorization: jwt_for(user) }
        end

        it 'returns all tickets' do
          expect(response.status).to eq 200
          expect(response.body).to eq({
            tickets: [ticket_hash(user_ticket), ticket_hash(another_ticket)]
          }.to_json)
        end
      end
    end

    context 'as not authorized user' do
      before { get api_v1_tickets_path }

      it_behaves_like 'authentication error'
    end
  end

  describe 'GET /tickets/:id' do
    context 'as a customer user' do
      context 'and ticket author' do
        before { get api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) } }

        it 'returns serialized ticket' do
          expect(response.status).to eq 200
          expect(response.body).to eq({ ticket: ticket_hash(user_ticket) }.to_json)
        end
      end

      context 'and not ticket author' do
        before { get api_v1_ticket_path(another_ticket), headers: { authorization: jwt_for(user) } }

        it 'returns not authorized error status' do
          expect(response.status).to eq 401
        end
      end
    end

    %w(support admin).each do |role|
      context "as a #{role} user" do
        before { user.public_send("#{role}!") }

        context 'and ticket author' do
          before { get api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) } }

          it 'returns serialized ticket' do
            expect(response.status).to eq 200
            expect(response.body).to eq({ ticket: ticket_hash(user_ticket) }.to_json)
          end
        end

        context 'and not ticket author' do
          before { get api_v1_ticket_path(another_ticket), headers: { authorization: jwt_for(user) } }

          it 'returns serialized ticket' do
            expect(response.status).to eq 200
            expect(response.body).to eq({ ticket: ticket_hash(another_ticket) }.to_json)
          end
        end
      end
    end
  end

  describe 'POST /tickets' do
    let(:new_ticket) { build :ticket }
    let!(:tickets_count) { user.tickets.count }

    context 'as authorized user' do
      before do
        post api_v1_tickets_path, headers: { authorization: jwt_for(user) },
                                  params: { ticket: { title: new_ticket.title, description: new_ticket.description } }
      end

      it 'creates new ticket authored by user' do
        expect(response.status).to eq 200
        expect(response.body).to eq({ ticket: ticket_hash(Ticket.last) }.to_json)
        expect(user.tickets.count).to eq tickets_count + 1
      end
    end

    context 'as not authorized user' do
      before do
        post api_v1_tickets_path,  params: { ticket: { title: new_ticket.title, description: new_ticket.description } }
      end

      it 'returns not authorized error status' do
        expect(response.status).to eq 401
        expect(user.tickets.count).to eq tickets_count
      end
    end
  end

  describe 'PUT /tickets/:id' do
    context 'as authorized user' do
      before do
        put api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) },
                                             params: { ticket: { title: 'New title' } }
      end

      it 'updates ticket' do
        expect(response.status).to eq 200
        hash = ticket_hash(user_ticket)
        hash[:title] = 'New title'
        expect(response.body).to eq({ ticket: hash }.to_json)
      end
    end

    context 'as not authorized user' do
      before do
        put api_v1_ticket_path(another_ticket), headers: { authorization: jwt_for(user) },
                                                params: { ticket: { title: 'New title' } }
      end

      it_behaves_like 'authentication error'
    end
  end

  describe 'DELETE /tickets/:id' do
    context 'as authorized user' do
      before { delete api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) } }

      it 'deletes ticket' do
        expect(response.status).to eq 204
      end
    end

    context 'as not authorized user' do
      before { delete api_v1_ticket_path(another_ticket), headers: { authorization: jwt_for(user) } }

      it_behaves_like 'authentication error'
    end
  end

  describe 'POST /tickets/:id/change_status' do
    context 'as customer user' do
      before do
        post change_status_api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) },
                                                            params: { event: 'start' }
      end

      it_behaves_like 'authentication error'
    end

    %w(support admin).each do |role|
      context "as #{role} user" do
        before { user.public_send("#{role}!") }
        context 'with existing event' do
          before do
            post change_status_api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) },
                                                                params: { event: 'start' }
          end

          it 'returns ticket with new status' do
            expect(response.status).to eq 200
            hash = ticket_hash(user_ticket)
            hash[:status] = 'in_progress'
            expect(response.body).to eq({ ticket: hash }.to_json)
          end
        end

        context 'with nonexistent event' do
          before do
            post change_status_api_v1_ticket_path(user_ticket), headers: { authorization: jwt_for(user) },
                                                                params: { event: 'non_existent' }
          end

          it 'return ticket without changes' do
            expect(response.status).to eq 200
            expect(response.body).to eq({ ticket: ticket_hash(user_ticket) }.to_json)
          end
        end
      end
    end


  end

  def ticket_hash(ticket)
    {
      id: ticket.id,
      title: ticket.title,
      description: ticket.description,
      status: ticket.status,
      author: {
        name: ticket.author.name,
        email: ticket.author.email
      }
    }
  end
end
