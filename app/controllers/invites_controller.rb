class InvitesController < ApplicationController
  def create
    Invite.create!(invite_params)
    return render text: "Created", status: 201
  end

  def destroy
    invite = Invite.find(params[:id])
    invite.destroy
    return render text: "Success", status: 200
  end

  def show
    invite = Invite.find(params[:id])
    return render json: invite
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
