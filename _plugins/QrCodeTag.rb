# Modification of the plugin from
# http://www.createdbypete.com/articles/create-a-custom-liquid-tag-as-a-jekyll-plugin/

require 'rqrcode_png'

module JekyllPlugin
  class QrCodeTag < JekyllPlugin::TagPluginMultiParam

    # constants
    @@PARAMETERS = %w(size)
    @@DEFAULTS = {:size => '20'}

    # Constructor
    def initialize(tag_name, markup, tokens)
      # Init the Base Class
      super('qrcode', tag_name, markup, tokens)
      # first argument (required) is url of qrcode, @params will be defined by the base class
      @qrurl = @params.shift.strip
    end

    # Render Tag on Page
    def render(context)
      page_url = @qrurl
      qr = RQRCode::QRCode.new(page_url, size: @config[:size].to_i)
      png = qr.to_img
      <<-MARKUP.strip
      <div class="qrcode">
        <img src="#{png.to_data_url}" alt="#{page_url}">
      </div>
      MARKUP
    end

  end
end

Liquid::Template.register_tag('qrcode', JekyllPlugin::QrCodeTag)
