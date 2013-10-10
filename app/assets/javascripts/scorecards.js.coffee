# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $(".new_scorecard").on("ajax:success", (e, data, status, xhr) ->
    alert 'success!'
  ).bind "ajax:error", (e, xhr, status, error) ->
    # alert 'error!! ' + xhr.responseText
    # $('#update-container-' + )