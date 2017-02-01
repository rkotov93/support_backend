# frozen_string_literal: true
class TicketPolicy < ApplicationPolicy
  def show?
    record.author == user || user.support? || user.admin?
  end

  def create?
    true
  end

  def update?
    !record.solved? && (record.author == user || user.admin?)
  end

  def destroy?
    record.author == user || user.admin?
  end

  def change_status?
    user.support? || user.admin?
  end

  class Scope < Scope
    def resolve
      if user.support? || user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
