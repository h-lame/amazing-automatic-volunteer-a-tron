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

    def interesting_event_horizon
      @interesting_event_horizon
    end

    def interesting_event_horizon=(new_event_horizon)
      @interesting_event_horizon = new_event_horizon
    end
  end
end

require 'date'

VolunteerATron.turn_caching_on
VolunteerATron.interesting_event_horizon= (Date.today << 2) # 2 months ago (ish)