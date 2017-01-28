class Ticket < ApplicationRecord
  include Workflow

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

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
