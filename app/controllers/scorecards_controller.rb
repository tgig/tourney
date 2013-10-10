class ScorecardsController < ApplicationController
  def show
    @path = Scorecard.new
  end

  def create
    @player = Player.find(params[:player_id])

    params[:scorecard].each do |scorecard|
      @player.scorecards.create(scorecard)
      # Rails.logger.debug('scorecards: ' + scorecard.inspect)
    end

    redirect_to player_path(@player), notice: "Scorecard was successfully added to tourney"

=begin
    respond_to do |format|
      if @player.scorecards.create(scorecard_params)
        format.html { redirect_to @player, notice: "Scorecard was successfully added to tourney" }
        format.js {}
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
=end

  end

  def preview
    @player = Player.find(params[:scorecard_id])
    @scorecard = @player.scorecards.new
    @path = [@player, @scorecard]
    # Rails.logger.debug("player = " + @player.inspect)
    player_handicap = @player.handicap
    if params[:id_type] == 'round'
      get_sbs_round_scorecard(params[:sbs_scorecard_round_id], @player.sbs_player_id, player_handicap)
    else
      get_sbs_scorecard(params[:sbs_scorecard_round_id], player_handicap)
    end
  end

  private
    def scorecard_params
      params.require(:scorecard).permit(:sbs_scorecard_id, :sbs_round_id, :course_name, :course_city, :course_state, :course_country, :tee_box, :course_rating, :course_slope, :player_course_handicap, :score_type_front_back_full, :raw_score, :handicap_adjusted_score, :stableford_score, :round_track_url, :round_date)
    end

    #### THIS STUFF PROBABLY GOES SOMEWHERE ELSE, BUT IT'S HERE FOR NOW, WILL RE-FACTOR LATER

    def get_sbs_round_scorecard(sbs_round_id, sbs_player_id, player_handicap)
      # compile api url and grab data
      sbs_scorecard_id = 0
      sbs_round_url = Contest::Application::SBS_URI_BASE + 'scorecards?roundId=' + sbs_round_id + '&' + Contest::Application::SBS_ACCESS_TOKEN
      sbs_round = HTTParty.get(sbs_round_url)
      # loop through results, if any, and try to match up a player_id
      if sbs_round['scorecards'].count > 0
        sbs_round['scorecards'].each do |scorecard|
          # Rails.logger.debug('scorecard => ' + scorecard.inspect)
          if scorecard['playerId'] == sbs_player_id
            sbs_scorecard_id = scorecard['scorecardId']
          end
        end

        # if scorecard id was found, get that data, if nothing was found, return message
        if sbs_scorecard_id == 0
          @notice = "No scorecards found for player id " + sbs_player_id.to_s + " on this round"
        else
          return get_sbs_scorecard(sbs_scorecard_id, player_handicap)
        end
      else
        @notice = "No data returned for Round Id = " + sbs_round_id.to_s
      end
    end

    def get_sbs_scorecard(sbs_scorecard_id, player_handicap)
      scorecard_url = Contest::Application::SBS_URI_BASE + 'scorecards/' + sbs_scorecard_id.to_s + '?' + Contest::Application::SBS_ACCESS_TOKEN
      # Rails.logger.debug('scorecard_url: ' + scorecard_url)
      sbs_scorecard = HTTParty.get(scorecard_url)
      sbs_course_id = sbs_scorecard['courseId'].to_s
      course_url = Contest::Application::SBS_URI_BASE + 'courses/' + sbs_course_id + '?' + Contest::Application::SBS_ACCESS_TOKEN
      # Rails.logger.debug('course_url: ' + course_url)
      sbs_course = HTTParty.get(course_url)

      # Rails.logger.debug('sbs_scorecard: ' + sbs_scorecard.to_s)
      # Rails.logger.debug('sbs_course: ' + sbs_course.to_s)

      # send in Hash array of all course stats to get the rating and slope for the tee boxes played
      rating_slope_data = get_sbs_scorecard_stat(sbs_course['stats'], sbs_scorecard['teeTypeId'])

      # do we have what we need to validate that this is a good course
      if !validate_scorecard(sbs_scorecard, rating_slope_data)
        return false
      end

      player_course_handicap = get_player_course_handicap(rating_slope_data, player_handicap)
      score_datas = get_score_data(sbs_scorecard['holes'], player_course_handicap)

      @scorecards = []

      score_datas.each do |key, score_data|
        # Rails.logger.debug('score_data: ' + score_data.inspect)

        scorecard = Scorecard.new do |s|
          s.sbs_scorecard_id = sbs_scorecard_id
          s.sbs_round_id = sbs_scorecard['roundId']
          s.course_name = sbs_scorecard['courseName']
          s.course_city = sbs_course['city']
          s.course_state = sbs_course['stateOrProvince']
          s.course_country = sbs_course['country']
          s.tee_box = sbs_scorecard['teeType']
          s.course_rating = rating_slope_data['rating']
          s.course_slope = rating_slope_data['slope']
          s.player_course_handicap = player_course_handicap
          s.score_type_front_back_full = key
          s.raw_score = score_data['raw_score']
          s.handicap_adjusted_score = score_data['handicap_adjusted_score']
          s.stableford_score = score_data['stableford_score']
          s.round_track_url = Contest::Application::SBS_ROUND_TRACK_BASE + sbs_scorecard['roundId'].to_s + '/' + sbs_scorecard['playerId'].to_s
          s.round_date = sbs_scorecard['updated']
        end
        @scorecards.push(scorecard)
      end

    end

    def validate_scorecard(sbs_scorecard, rating_slope_data)
      # things that need to be true for this to be a valid scorecard
      #  at least 9 holes
      #  stroke indexes
      #  rating
      #  slope

      if sbs_scorecard['holes'].count < 9
        @notice = 'Scorecard does not have at least 9 holes'
        return false
      elsif sbs_scorecard['holes'][0]['strokeIndex'].nil?
        @notice = 'Course does not have stroke indexes entered'
        return false
      elsif rating_slope_data['rating'] == 0 || rating_slope_data['slope'] == 0
        @notice = 'Course slope/rating is not entered'
        return false
      end

      return true

    end

    def get_sbs_scorecard_stat(stats, tee_type_id)

      data = Hash.new

      # Rails.logger.debug("tee_type_id: " + tee_type_id.to_s)
      # Rails.logger.debug("stats: " + stats.to_s)

      stats.each do |stat|
        if stat['teeTypeId'].to_i == tee_type_id.to_i
          # Rails.logger.debug("stat: " + stat.to_s)
          if !stat['rating'].nil?
            data['rating'] = stat['rating']
          else
            data['rating'] = 0
          end
          if !stat['slope'].nil?
            data['slope'] = stat['slope']
          else
            data['slope'] = 0
          end
        end
      end

      return data
    end

    def get_player_course_handicap(rating_slope_data, player_handicap)
      hc = ((player_handicap * rating_slope_data['slope']) / 113).round
    end

    def get_score_data(holes, course_handicap)

      score = 0
      front_hole_count = 0
      front_raw_score = 0
      front_handicap_adjusted_score = 0
      front_stableford_score = 0
      back_hole_count = 0
      back_raw_score = 0
      back_handicap_adjusted_score = 0
      back_stableford_score = 0

      holes.each do |hole|
        score = hole['score']
        num_strokes_to_subtract = get_num_strokes(hole['strokeIndex'], course_handicap)
        handicap_adjusted_score = score - num_strokes_to_subtract
        stableford_score = get_stableford_score(hole['par'], handicap_adjusted_score)

        if hole['holeNum'].between?(1,9)
          front_hole_count += 1
          front_raw_score += score
          front_handicap_adjusted_score += (score - num_strokes_to_subtract)
          front_stableford_score += stableford_score
        elsif hole['holeNum'].between?(10,18)
          back_hole_count += 1
          back_raw_score += score
          back_handicap_adjusted_score += (score - num_strokes_to_subtract)
          back_stableford_score += stableford_score
        end
      end


      data = Hash.new
      if front_hole_count == 9
        data['front'] = Hash.new
        data['front']['raw_score'] = front_raw_score
        data['front']['handicap_adjusted_score'] = front_handicap_adjusted_score
        data['front']['stableford_score'] = front_stableford_score
      end
      if back_hole_count == 9
        data['back'] = Hash.new
        data['back']['raw_score'] = back_raw_score
        data['back']['handicap_adjusted_score'] = back_handicap_adjusted_score
        data['back']['stableford_score'] = back_stableford_score
      end

      return data
    end

    # get how many strokes this player will get on this specific hole
    def get_num_strokes(stroke_index, course_handicap)
      strokes = 0
      # loop until calc'd stroke_index is bigger than this person's handicap
      # Rails.logger.debug('stroke_index: ' + stroke_index.to_s)
      # Rails.logger.debug('course_handicap: ' + course_handicap.to_s)

      until stroke_index > course_handicap do
        if stroke_index <= course_handicap
          strokes += 1
        end
        # add 18 to stroke_index, if it's still smaller than the handicap, we will loop again
        stroke_index += 18
      end

      return strokes
    end

    #given a par and score, calculate the stableford score
    def get_stableford_score(par, score)
      score = (par - score) + 2
      if score < 0
        score = 0
      elsif score > 6
        score = 6
      end
      return score
    end
end

