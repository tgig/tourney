require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Contest
  class Application < Rails::Application
    SBS_URI_BASE = 'http://api.swingbyswing.com/v1/'
    SBS_ACCESS_TOKEN = 'access_token=gAAAAInEYExXoOtuomvurHBMxaY3Mm2de1RtY9W4-isb--hAKhGrd3q32dWJ67zHIn8O-bQCOO9BnYWjbZu6DDrpaJdu8vCr73cfgcgBN2EIcn2yWwzbfS5MkcseXM6-rj8OSbUn6q48SzmtvWia5pvqSuCTHJpvQqN31kBdXOl_H7K3FAEAAIAAAABSlG7zsFwX8I2XpmO-Z_zUmAkJJ3HCr_kRNDzO8LBzI9V-il-CqXgAZr7xv7yHmArmuUUd4LAM6Rt0zTO-oUBGvLulusM4V4z0D5-4dku4abl4vdHlOaysU0PjGgQrk2bT5QXxToL5GbLWstnqdsMUV71vlcu-qeNte9SKrQrwDcyToBkEpxVPk1uYFJAL2tkvu6TcVLCGqazmli3oa5ZY8luAbH5vBaPwwmHcc4xdnNMvubzvmbc41C0kNUW7QshiBil41wFpI1zbzqgYg3WDyQMte8vrS_eiXfEou54eU2lkNipKQhaxPSWUxT9r1XhsrIOn2CnNhuqEgE-kc24vaRSXpDGlY6daqC4teh9yHQ&scope=allsbs%20client%3A974dfaae-1b05-4522-89eb-8143f0f2d3b9'
    SBS_ROUND_TRACK_BASE = 'http://www.swingbyswing.com/myrounds/viewroundtrack/'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
