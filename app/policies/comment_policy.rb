# frozen_string_literal: true
class CommentPolicy < ApplicationPolicy
  def create?
    record.ticket.user_id == user.id || user.support? || user.admin?
  end

  def destroy?
    record.user_id == user.id || user.support? || user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
