require 'fileutils'

class VolunteerATron
  module Cachet
    def cachet_initialized?
      @cachet_initialized
    end

    def initialize_cachet
      FileUtils.mkdir_p('cachet')
      @cachet_initialized = true
    end

    def read_page(url)
      initialize_cachet unless cachet_initialized?
      add_cachet(super(url), url) unless cached?(url)
      read_cached_page(url)
    end
    
    def cached?(url)
      File.exists?(cachet_form(url))
    end
    
    def read_cached_page(url)
      puts "Reading #{url} from cache"
      open(cachet_form(url))
    end
    
    def add_cachet(io_stream, from_url)
      puts "Writing #{from_url} to cache"
      File.open(cachet_form(from_url),'w+') do |f|
        f.write(io_stream.read)
      end
    end

    def cachet_form(url)
      "./cachet/#{url.downcase.gsub(/[^a-z0-9]/,'_')}.cachet"
    end
  end
end