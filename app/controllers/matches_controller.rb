class MatchesController < ApplicationController
  def index
    @lost_item = LostItem.find(params[:lost_item_id])
    @matches = @lost_item.matches
  end

  def show
    @lost_item = LostItem.find(params[:lost_item_id])
    @match = @lost_item.matches.includes(:found_item).find(params[:id])
    @step = params[:step].to_i > 0 ? params[:step].to_i : 1
  end

  def update
    @lost_item = LostItem.find(params[:lost_item_id])
    @match = @lost_item.matches.find(params[:id])

    if @match.update(match_params)
      finalize = params[:match][:finalize]

      if @match.confirmed == false
        next_match = @lost_item.matches.where("id > ?", @match.id).where(confirmed: [nil, false]).first
        if next_match
          redirect_to lost_item_match_path(@lost_item, next_match, step: next_match.step || 1), notice: "Match rejected, next."
        else
          redirect_to lost_item_path(@lost_item), notice: "No more matches."
        end

      elsif finalize.present?
        redirect_to root_path, notice: "Thank you! Match confirmed."
      else
        redirect_to lost_item_match_path(@lost_item, @match, step: @match.step), notice: "Match updated."
      end

    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def match_params
    params.require(:match).permit(:confirmed, :step)
  end
end
