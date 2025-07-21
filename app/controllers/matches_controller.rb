class MatchesController < ApplicationController
  def index
    @matches = Match
               .joins(:lost_item, :found_item)
               .where("lost_items.user_id = ? OR found_items.user_id = ?", current_user.id, current_user.id)
               .where(confirmed: false)
               .includes(:lost_item, :found_item)
  end

  def update
    @match = Match.find(params[:id])

    unless [@match.lost_item.user_id, @match.found_item.user_id].include?(current_user.id)
      redirect_to matches_path, alert: "Not authorized." and return
    end

    @match.update!(confirmed: true)

    redirect_to matches_path, notice: "Match confirmed !"
  end
end
