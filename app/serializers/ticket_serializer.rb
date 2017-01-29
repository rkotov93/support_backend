# frozen_string_literal: true
class TicketSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :author

  def author
    {
      name: object.author.name,
      email: object.author.email
    }
  end
end
