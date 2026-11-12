require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skandies
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0 

    # Settings in config/environments/* take precedence over those specified here.
    config.time_zone = 'Central Time (US & Canada)'


    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.autoload_paths << Rails.root.join('lib')
  end
end
