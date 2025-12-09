class CalendrierPolicy < ApplicationPolicy
  def show?
    # L'utilisateur peut voir son propre calendrier
    return true if record == user

    # Un membre de l'entourage peut voir le calendrier du propriétaire
    record.entourage&.member?(user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end
end
