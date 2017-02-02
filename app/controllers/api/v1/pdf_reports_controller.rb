# frozen_string_literal: true
module Api
  module V1
    class PdfReportsController < BaseController
      def generate
        current = Time.zone.now
        PdfReportGeneratorJob.perform_later current_user.id, (current - 1.month).to_s, current.to_s
      end

      def info
        render json: { url: current_user.pdf_report.url }
      end
    end
  end
end
