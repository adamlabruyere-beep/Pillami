class ReminderPolicy < ApplicationPolicy
  def index?
    record == user
  end

  def show?
    record.user == user
  end

  def new?
    record.user == user
  end

  def create?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end
end
