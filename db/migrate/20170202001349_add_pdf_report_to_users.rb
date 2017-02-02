# frozen_string_literal: true
class AddPdfReportToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pdf_report, :string
  end
end
