###
### $Release: $
### $Copyright$
### $License$
###


# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  default_conf = {
    :show_area   => false,
    :root_dir    => nil,
    :cache_store => nil,
  }
  curr_conf = Merb::Plugins.config[:merb_piece_cache]
  Merb::Plugins.config[:merb_piece_cache] = default_conf.merge(curr_conf || {})

  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
    require 'merb-cache/cache'
    require 'merb_piece_cache/file_cache_store'
    require 'merb_piece_cache/helpers'
    begin
      require 'called_from.so'
    rescue LoadError
      require 'called_from.rb'
      Merb.logger.info "[piece_cache] it is strongly recommended to install 'called_from.so' instead of 'called_from.rb' for good performance"
    end
  end

  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
    cache_store = Merb::Plugins.config[:merb_piece_cache][:cache_store]
    if cache_store
      Merb.logger.debug "[piece_cache] using #{cache_store.class}"
    else
      root_dir = Merb::Plugins.config[:merb_piece_cache][:root_dir]
      cache_store = PieceCache::FileCacheStore.new(:dir=>root_dir)
      Merb::Plugins.config[:merb_piece_cache][:cache_store] = cache_store
      Merb.logger.debug "[piece_cache] using #{cache_store.class} (root_dir=#{cache_store.dir})"
    end
  end

  #Merb::Plugins.add_rakefiles "merb_piece_cache/merbtasks"
end
