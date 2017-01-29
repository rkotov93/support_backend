# frozen_string_literal: true
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :author

  def author
    {
      name: object.author.name,
      email: object.author.email
    }
  end
end
