# frozen_string_literal: true

require 'jekyll-watch'

module Jekyll
  module Watch
    extend self

    if method_defined?(:listen_ignore_paths)
      alias_method :original_listen_ignore_paths, :listen_ignore_paths

      def listen_ignore_paths(options)
        original_listen_ignore_paths(options) + [%r!.*\.TMP!i]
      end
    else
      puts "[WARN] Jekyll::Watch.listen_ignore_paths não está disponível nesta versão do Jekyll."
    end
  end
end