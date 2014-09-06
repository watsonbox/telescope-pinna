require_relative 'liquid/tags/include'
require_relative 'liquid/tags/captcha'
require_relative 'liquid/tags/contact_form'
require_relative 'liquid/tags/paginate'
require_relative 'liquid/filters'

Liquid::Tags::Include::INCLUDES_DIR = 'snippets'
Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.join(Dir.pwd, 'snippets'))

class ThemeKit
  PATHS = {
    configs: 'configs',
    layouts: 'layouts',
    templates: 'templates',
    stylesheets: 'stylesheets',
    javascripts: 'javascripts'
  }

  class << self
    # Load offline store data from store.json
    def load_store
      @store = Hashie::Mash.new(JSON.parse(File.read('store.json')))
    end

    # Load default values from theme configuration file,
    # then add any locally configured values from store config if loaded
    def load_config
      settings = JSON.parse(File.read(File.join(PATHS[:configs], 'default.json')))['settings']
      config = {}

      settings.each do |k, v|
        config[k] = v['default'] if v['default']
      end

      if store && store.config
        store.config.each { |k, v| config[k] = v }
      end

      @config = config
    end

    def load
      load_store
      load_config
    end

    def store
      @store
    end

    def config
      @config
    end

    def render(file, liquid_assigns = nil)
      assigns = { 'config' => ThemeKit.config, 'store' => ThemeKit.store }

      if liquid_assigns
        liquid_assigns.each_key do |k|
          unless liquid_assigns[k].is_a?(Hashie::Mash)
            liquid_assigns[k] = Hashie::Mash.new(liquid_assigns[k])
          end
        end

        assigns.merge!(liquid_assigns.stringify_keys)
      end

      layout = Liquid::Template.parse(File.read(File.join(PATHS[:layouts], 'default.html')))
      template = Liquid::Template.parse(File.read(File.join(PATHS[:templates], file)))

      layout.render(assigns.merge('content' => template.render(assigns)))
    end
  end
end
