require 'open-uri'

class VolunteerATron
  module Reader
    def read_page(url)
      puts "Fetching #{url}"
      open(url)
    end
  end
end  
