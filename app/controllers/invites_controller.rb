class InvitesController < ApplicationController
  def create
    begin
      invite = Invite.create!(invite_params)
      return render json: [invite], status: 201
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def destroy
    begin
      invite = Invite.find(params[:id])
      invite.destroy
      return render json: invite, status: 200
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def show
    begin
      invite = Invite.find(params[:id])
      return render json: invite
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    invites = Invite.all
    return render json: invites
  end

  private
  def invite_params
    params.require(:invite).permit(:tenant_id, :recipient_email)
  end

end
