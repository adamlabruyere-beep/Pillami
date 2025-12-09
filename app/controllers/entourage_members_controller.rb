class EntourageMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entourage

  def create
    user_to_add = User.find_by(email: params[:email])

    if user_to_add.nil?
      redirect_to entourage_path, alert: "Aucun utilisateur trouvé avec cet email"
    elsif user_to_add == current_user
      redirect_to entourage_path, alert: "Vous ne pouvez pas vous ajouter vous-même"
    elsif @entourage.member?(user_to_add)
      redirect_to entourage_path, alert: "Cet utilisateur est déjà membre de votre entourage"
    else
      @entourage.add_member(user_to_add)
      redirect_to entourage_path, notice: "#{user_to_add.prenom} a été ajouté à votre entourage"
    end
  end

  def destroy
    member = @entourage.entourage_members.find(params[:id])
    member.destroy
    redirect_to entourage_path, notice: "Membre retiré de votre entourage"
  end

  private

  def set_entourage
    @entourage = current_user.entourage
  end
end
