class MatchesController < ApplicationController
  def index
    @lost_item = LostItem.find(params[:lost_item_id])
    @matches = @lost_item.matches
  end

  def show
    @lost_item = LostItem.find(params[:lost_item_id])
    @match = @lost_item.matches.includes(:found_item).find_by(id: params[:id])

    unless @match && @lost_item.user_id == current_user.id
      redirect_to root_path, alert: "You are not authorized to view this match."
      return
    end

    @step = params[:step].to_i.positive? ? params[:step].to_i : 1
  end

  def update
  @lost_item = LostItem.find(params[:lost_item_id])
  @match = @lost_item.matches.find_by(id: params[:id])

  # Only allow updates if current user owns the lost item
  unless @match && @lost_item.user_id == current_user.id
    redirect_to root_path, alert: "You are not authorized to view this match."
    return
  end

  if @match.update(match_params)
    finalize = ActiveModel::Type::Boolean.new.cast(params[:finalize])

    if @match.confirmed == false
      next_match = @lost_item.matches
        .joins(:found_item)
        .where("matches.id > ?", @match.id)
        .where(confirmed: [nil, false])
        .first
      if next_match
        redirect_to lost_item_match_path(@lost_item, next_match, step: next_match.step || 1), notice: "Match rejected, next."
      else
        redirect_to root_path, notice: "No more matches, returning home."
      end

    elsif finalize
      if @match.review.present?
        Notification.create!(
          user: @match.found_item.user,
          notifiable: @match,
          content: "#{current_user.first_name} left you a review: \"#{@match.review}\""
        )
      end

      redirect_to root_path, notice: "Thank you! Match confirmed."

    else
      redirect_to lost_item_match_path(@lost_item, @match, step: @match.step), notice: "Match updated."
    end

  else
    @step = @match.step || 1
    redirect_to root_path, alert: @match.errors.full_messages.join(", ")
    # Optionally: render :show, status: :unprocessable_entity
  end
end

  private

  def match_params
    params.require(:match).permit(:confirmed, :step, :review)
  end
end
