# frozen_string_literal: true
class Ticket < ApplicationRecord
  include Workflow

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true

  has_many :comments, dependent: :destroy
  belongs_to :author, -> { with_deleted }, class_name: 'User', foreign_key: 'user_id'

  scope :active, -> { where.not(status: 'solved') }
  scope :solved, -> { where(status: 'solved') }

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

  def self.pdf_report(start_date, finish_date)
    pdf_data = Ticket.solved.where(updated_at: start_date..finish_date).map do |t|
      [t.id.to_s, t.title, t.updated_at.to_s]
    end
    filename = "tmp/report_#{start_date.to_i}_#{finish_date.to_i}.pdf"

    Prawn::Document.generate(filename) do
      table pdf_data
    end

    File.open(filename)
  end
end
