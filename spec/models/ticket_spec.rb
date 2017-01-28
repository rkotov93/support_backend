# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Ticket, type: :model do
  subject(:ticket) { create :ticket }

  its(:status) { is_expected.to eq 'new' }

  describe '#start! method' do
    before { ticket.start! }

    its(:status) { is_expected.to eq 'in_progress' }
  end

  describe '#resolve! method' do
    context 'from new state' do
      before { ticket.resolve! }

      its(:status) { is_expected.to eq 'solved' }
    end

    context 'from in_progress state' do
      before { ticket.resolve! }

      its(:status) { is_expected.to eq 'solved' }
    end
  end
end
