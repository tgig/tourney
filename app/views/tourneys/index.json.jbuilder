json.array!(@tourneys) do |tourney|
  json.extract! tourney, :name, :description, :startdate, :enddate
  json.url tourney_url(tourney, format: :json)
end
