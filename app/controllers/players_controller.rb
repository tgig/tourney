class PlayersController < ApplicationController
  # GET /tourneys/:id
  def create
    @tourney = Tourney.find(params[:tourney_id])
    @player = @tourney.players.create(player_params)
    redirect_to tourney_path(@tourney)
  end

  def show
    @player = Player.find(params[:id])
    @tourney = Tourney.find(@player.tourney_id)
    @scorecard = Scorecard.new
    @path = [@player, @scorecard]

    # get roundoverviews for this player
    round_url = Contest::Application::SBS_URI_BASE + 'roundtotals/?playerId=' + @player.sbs_player_id.to_s + '&' + Contest::Application::SBS_ACCESS_TOKEN
    @sbs_rounds = HTTParty.get(round_url)

    # remove rounds that already exist
    @sbs_rounds['roundTotals'].each do |round|
      # Rails.logger.debug('round: ' + round.to_s)
      # if @player.scorecards.sbs_round_id.include?(round['roundId'])
      if @player.scorecards.any?{|s| s.sbs_round_id == round['roundId'] }
        @sbs_rounds['roundTotals'].delete(round)
      end
    end
  end

  # GET /tourneys/:tourney_id/players/:id/edit
  def edit
    @player = Player.find(params[:id])
    @tourney = Tourney.find(@player.tourney_id)
  end

  # PATCH/PUT /tournes/:tourney_id/players/:id
  def update
    @player = Player.find(params[:id])
    @tourney = Tourney.find(@player.tourney_id)
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @tourney, notice: 'Player was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @player.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @tourney = Tourney.find(@player.tourney_id)
    @player.destroy
    redirect_to tourney_path @tourney, notice: 'Player was successfully deleted'
  end

  private
    def player_params
      params[:player].permit(:sbs_player_id, :first_name, :last_name, :handicap)
    end
end
