require_relative 'boot'

require 'rails/all'

require 'rqrcode'
require File.expand_path('../application', __FILE__)
require 'rqrcode_png'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tkbnet
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = "Europe/Zurich"
    config.i18n.default_locale = :de

  end
end
