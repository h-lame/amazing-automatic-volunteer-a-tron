require 'date'

class VolunteerATron
  class << self
    attr_accessor :interesting_event_horizon
    attr_accessor :popularity_threshold

    def use_caching?
      @use_caching
    end

    def turn_caching_off
      @use_caching = false
    end

    def turn_caching_on
      @use_caching = true
    end

    def use_rate_limiting?
      !@rate_limiting.nil?
    end

    def limit_my_rate(base)
      if use_rate_limiting?
        rate_limit_module = @rate_limiting
        base.class.class_eval { include rate_limit_module }
      end
    end

    def turn_off_rate_limiting
      @rate_limiting = nil
    end

    def use_spurty_rate_limiting
      @rate_limiting = VolunteerATron::Throttler::Hare
    end

    def use_steady_rate_limiting
      @rate_limiting = VolunteerATron::Throttler::Tortoise
    end

    def initial_setup_run?
      @initial_setup_run ||= false
    end

    def run_initial_setup(&block)
      @initial_setup_run = true
      yield self
    end
  end
end

unless VolunteerATron.initial_setup_run?
  VolunteerATron.run_initial_setup do |config|
    config.turn_caching_on
    config.interesting_event_horizon = (Date.today << 2) # 2 months ago (ish)
    config.popularity_threshold = 2 # http://sivers.org/ff
    config.use_spurty_rate_limiting
  end
end
