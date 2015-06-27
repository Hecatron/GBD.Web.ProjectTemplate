# Base Class for Liquid Tag Plugins that use multiple parameters
# Code based on https://github.com/sectore/jekyll-swfobject/blob/master/lib/jekyll-swfobject.rb#L68

module JekyllPlugin
  class TagPluginMultiParam < Liquid::Tag

    # constants
    @@PARAMETERS = %w(
    )

	@@DEFAULTS = {
    }

    def self.DEFAULTS
      return @@DEFAULTS
    end

    def setconfigs(config)
      config.each{ |key,value| @config[key] = value }
    end

    # Constructor
    def initialize(plugin_name, tag_name, markup, tokens)
      super(tag_name, markup, tokens)
      @config = {}

	  # set defaults
      setconfigs(@@DEFAULTS)

      # override configuration with values defined within _config.yml
      if Jekyll.configuration({}).has_key?(plugin_name)
        config = Jekyll.configuration({})[plugin_name]
        setconfigs(config)
      end

      # Parse the list of parameters
      @params = markup.split

      if @params.size > 0
        # override configuration with parameters defined within {% qrcode qrpath %}
        config = {} # reset local config
        @params.each do |param|
          param = param.gsub /\s+/, '' # remove whitespaces
          key, value = param.split(':',2) # split first occurrence of ':' only
          config[key.to_sym] = value
        end
        setconfigs(config)
      end
    end

  end
end
