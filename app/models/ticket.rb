class Ticket < ApplicationRecord
  include Workflow

  belongs_to :user

  workflow_column :status
  workflow do
    state :new do
      event :start, transitions_to: :in_progress
      event :resolve, transitions_to: :solved
    end

    state :in_progress do
      event :resolve, transitions_to: :solved
    end

    state :solved
  end
end
