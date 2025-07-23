class MatchesController < ApplicationController
  def index
    @lost_item = LostItem.find(params[:lost_item_id])
    @matches = @lost_item.matches
  end

  def show
    @lost_item = LostItem.find(params[:lost_item_id])
    @match = @lost_item.matches.find(params[:id])
  end

  def update
    @lost_item = LostItem.find(params[:lost_item_id])
    @match = @lost_item.matches.find(params[:id])

    if @match.update(match_params)

      next_match = @lost_item.matches.where("id > ?", @match.id).where(confirmed: [nil, false]).first

      if next_match
        redirect_to lost_item_match_path(@lost_item, next_match), notice: "Match updated !"
      else
        redirect_to lost_item_path(@lost_item), notice: "More matches to check"
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def match_params
    params.require(:match).permit(:confirmed)
  end
end
