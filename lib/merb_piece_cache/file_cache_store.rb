###
### $Release: $
### $Copyright$
### $License$
###


module PieceCache


  class FileCacheStore < Merb::Cache::FileStore

    def pathify(key, parameters = {})
      filename = super
      ctype = parameters[:content_type]
      ctype ? "#{filename}.#{ctype}" : filename
    end

    def read(key, parameters = {})
      ## if cache file is not found, return nil
      fpath = pathify(key)  # or pathify(key, parameters)
      return nil unless File.exist?(fpath)
      ## if cache file is created before timestamp, return nil
      timestamp = parameters[:timestamp]
      return nil if timestamp && File.ctime(fpath) < timestamp
      ## if cache file is expired, return nil
      return nil if File.mtime(fpath) <= Time.now
      ## return cache file content
      return read_file(fpath)
    end

    MAX_TIMESTAMP = Time.at(0x7fffffff)  # Tue Jan 19 03:14:07 UTC 2038

    def write(key, data = nil, parameters = {}, conditions = {})
      ## create directory for cache
      fpath = pathify(key)  # or pathify(key, parameters)
      dir = File.dirname(fpath)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
      ## write data into file
      File.unlink(fpath) if File.exist?(fpath)
      write_file(fpath, data)
      ## set mtime (which is regarded as cache expired timestamp)
      lifetime = parameters[:lifetime]
      timestamp = lifetime && lifetime > 0 ? Time.now + lifetime : MAX_TIMESTAMP
      File.utime(timestamp, timestamp, fpath)
      ## return data
      return data
    end

    if RUBY_PLATFORM =~ /mswin(?!ce)|mingw|cygwin|bccwin/i
      def read_file(path)
        File.open(path, 'rb') {|f| f.read() }
      end
    else
      def read_file(path)
        File.read(path)
      end
    end

    def write_file(path, data)
      ## write into tempoary file and rename it to path (in order not to call flock)
      tmppath = "#{path}#{rand().to_s[1,6]}"
      begin
        File.open(tmppath, 'wb') {|f| f.write(data) }
        File.rename(tmppath, path)
      rescue => ex
        File.unlink tmppath if File.exist?(tmppath)
        File.unlink path    if File.exist?(path)
        raise ex
      end
      true
    end

  end


end
