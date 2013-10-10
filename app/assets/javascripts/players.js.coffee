# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

api_base = 'http://api.swingbyswing.com/v1/'
api_option_basic = 'loadtype=Basic'
access_token = 'access_token=gAAAAInEYExXoOtuomvurHBMxaY3Mm2de1RtY9W4-isb--hAKhGrd3q32dWJ67zHIn8O-bQCOO9BnYWjbZu6DDrpaJdu8vCr73cfgcgBN2EIcn2yWwzbfS5MkcseXM6-rj8OSbUn6q48SzmtvWia5pvqSuCTHJpvQqN31kBdXOl_H7K3FAEAAIAAAABSlG7zsFwX8I2XpmO-Z_zUmAkJJ3HCr_kRNDzO8LBzI9V-il-CqXgAZr7xv7yHmArmuUUd4LAM6Rt0zTO-oUBGvLulusM4V4z0D5-4dku4abl4vdHlOaysU0PjGgQrk2bT5QXxToL5GbLWstnqdsMUV71vlcu-qeNte9SKrQrwDcyToBkEpxVPk1uYFJAL2tkvu6TcVLCGqazmli3oa5ZY8luAbH5vBaPwwmHcc4xdnNMvubzvmbc41C0kNUW7QshiBil41wFpI1zbzqgYg3WDyQMte8vrS_eiXfEou54eU2lkNipKQhaxPSWUxT9r1XhsrIOn2CnNhuqEgE-kc24vaRSXpDGlY6daqC4teh9yHQ&callback=?'

$(document).on('click', '#lnk-get-sbs-player', ( (evt) ->
  evt.preventDefault()
  sbs_player_id = $('#player_sbs_player_id').val()

  if sbs_player_id is null or sbs_player_id is ''
    alert 'Please enter the SBS player id'
    return false

  $('#player_first_name').val('')
  $('#player_last_name').val('')
  $('#player_handicap').val('')
  # disable link for a sec
  $('#lnk-get-sbs-player').text('searching...')
  setTimeout =>
      $('#lnk-get-sbs-player').text('Retrieve player info from SBS')
    , 3000
  # try to get player info from sbs api
  getPlayerData sbs_player_id
));

$(document).on('click', '.js-add-existing-sbs-scorecard', ( (evt) ->
  evt.preventDefault()
  $(evt.currentTarget).css('color', '#ccc').text('Loading preview...')
  $('#id_type_round').prop('checked', true)
  $('#sbs_scorecard_round_id').val($(evt.currentTarget).data('round-id'))
  $('#preview_form').submit()
));

$(document).ready ->

  $('#new_player').submit (evt) ->
    if $('#player_sbs_player_id').val() is ''
      alert 'Please enter an sbs player id, or 0 if this is not an active sbs player'
      evt.preventDefault()
    else if $('#player_first_name').val() is ''
      alert 'Please enter a first name for this player'
      evt.preventDefault()
    else if $('#player_handicap').val() is ''
      alert 'Please enter a handicap for this player'
      evt.preventDefault()

  $('#preview_form').submit (evt) ->
    if $('#sbs_scorecard_round_id').val() is ''
      alert 'Please input an SbS Round Id or Scorecard Id'
      evt.preventDefault()





getPlayerData = (player_id) ->
  # build url
  sbs_url = api_base + 'players/' + player_id + '?' + api_option_basic + '&' + access_token
  # grab url, call function to populate
  try
    $.getJSON sbs_url, (data) ->
      populatePlayerOverview data

  catch error
    alert 'try/catch error: ' + error

  false

populatePlayerOverview = (player) ->
  try
    $('#player_first_name').val(player.firstName)
    $('#player_last_name').val(player.lastName)
    handicap = player.handicap
    if handicap is '' or handicap is null
      showHandicapError true
    else
      $('#player_handicap').val(handicap)
      showHandicapError false

  catch error
    alert 'error populating scorecard data: ' + error

  $('#lnk-get-sbs-player').text('Retrieve player info from SBS')

  false

showHandicapError = (toggle) ->
  if toggle is true
    $("label[for='player_handicap']").css('color', 'red').text('Handicap (please manually enter handicap)')
  else
    $("label[for='player_handicap']").css('color', '').text('Handicap')
