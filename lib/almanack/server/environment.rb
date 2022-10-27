module Almanack
  module ServerContext
    module Environment
      def basename(file)
        Pathname(file).split.last.to_s.split('.', 2).first
      end

      def locate_asset(name, within: path)
        name = basename(name)
        path = settings.root.join(within)
        available = Pathname.glob(path.join('*'))
        asset = available.find { |p| basename(p) == name }
        raise "Could not find stylesheet #{name} inside #{available}" if asset.nil?

        asset
      end

      def auto_render_template(asset)
        renderer = asset.extname.split('.').last
        content = asset.read
        respond_to?(renderer) ? send(renderer, content) : content
      end

      def auto_render_asset(name, within)
        auto_render_template locate_asset(name, within: within[:within])
      end

      def theme_stylesheet_path
        settings.root.join('stylesheets')
      end

      def register_sass_loadpaths!
        SassC.load_paths << theme_stylesheet_path unless SassC.load_paths.include?(theme_stylesheet_path)
      end
    end
  end
end
