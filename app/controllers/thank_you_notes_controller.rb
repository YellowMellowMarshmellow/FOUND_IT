class ThankYouNotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @thank_you_notes = ThankYouNote.where(recipient: @user)
  end

  def show
    @thank_you_note = ThankYouNote.find(params[:id])

    unless @thank_you_note.recipient == current_user
      redirect_to root_path, alert: "You are not authorized to view this thank-you note."
    end
  end

  def new
    @thank_you_note = ThankYouNote.new
  end

  def create
    @thank_you_note = ThankYouNote.new(thank_you_note_params)
    @thank_you_note.recipient = @user
    if @thank_you_note.save
      redirect_to user_thank_you_notes_path(@user), notice: "Note sent!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def thank_you_note_params
    params.require(:thank_you_note).permit(:message)
  end
end
