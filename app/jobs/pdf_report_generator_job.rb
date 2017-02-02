# frozen_string_literal: true
class PdfReportGeneratorJob < ApplicationJob
  queue_as :default

  def perform(user_id, start_date, finish_date)
    user = User.find(user_id)
    user.remove_pdf_report!
    user.save

    start_date = Time.zone.parse(start_date)
    finish_date = Time.zone.parse(finish_date)

    user.pdf_report = Ticket.pdf_report(start_date, finish_date)
    user.save
  end
end
