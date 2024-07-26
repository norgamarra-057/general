require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RaasInfo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.paths << Rails.root.join('toolstrap', 'assets', 'images')
    config.assets.paths << Rails.root.join('toolstrap', 'assets', 'javascripts')
    config.assets.paths << Rails.root.join('toolstrap', 'assets', 'stylesheets')
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
