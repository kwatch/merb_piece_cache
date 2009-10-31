###
### $Release: $
### $Copyright$
### $License$
###


module Merb
  module GlobalHelpers

    def if_not_cached(&block)
      @_callback = block    # or @_deffered?
    end

    def piece_cache(cache_key, lifetime=nil)
      #caller_str = caller(1)[0]    # caller() is too high cost to use in production mode
      #template_path = caller_str =~ /:\d+:in `/ && $`   #`
      template_path, linenum, funcname = called_from()
      ts = File.exist?(template_path) && File.mtime(template_path)
      cache_store = Merb::Plugins.config[:merb_piece_cache][:cache_store]
      piece = cache_store.read(cache_key, :timestamp=>ts, :content_type=>self.content_type)
      show_area = Merb::Plugins.config[:merb_piece_cache][:show_area]
      if piece
        Merb.logger.debug "[piece_cache] #{cache_key.inspect}: found."
        @_erb_buf << "<div style=\"font-weight:bold\">----- cached key=#{cache_key.inspect} -----</div>\n" if show_area
        @_erb_buf << piece
        @_erb_buf << "<div style=\"font-weight:bold\">----- /cached -----</div>\n" if show_area
      else
        Merb.logger.debug "[piece_cache] #{cache_key.inspect}: expired or not found."
        values = @_callback && @_callback.call(cache_key) || {}
        #values.each_pair {|k, v| self.instance_variable_set("@#{k}", v) } if values.is_a?(Hash)
        @_erb_buf << "<div style=\"font-weight:bold;color:red\">----- rendered key=#{cache_key.inspect} -----</div>\n" if show_area
        pos = @_erb_buf.length
        yield(values)
        piece = @_erb_buf[pos..-1]
        @_erb_buf << "<div style=\"font-weight:bold;color:red\">----- /rendered -----</div>\n" if show_area
        cache_store.write(cache_key, piece, :lifetime=>lifetime, :content_type=>self.content_type)
      end
      nil
    end

    alias cache_with piece_cache

  end
end
