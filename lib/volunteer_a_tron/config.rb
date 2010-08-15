class VolunteerATron
  class << self
    def use_caching?
      @use_caching
    end
    
    def turn_caching_off
      @use_caching = false
    end
    
    def turn_caching_on
      @use_caching = true
    end
  end
end

VolunteerATron.turn_caching_on