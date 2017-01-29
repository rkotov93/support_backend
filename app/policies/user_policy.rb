class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def change_role?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
