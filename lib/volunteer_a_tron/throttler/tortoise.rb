class VolunteerATron
  module Throttler
    module Tortoise
      class << self
        def time_between_messages
          VolunteerATron::Throttler.rate_period.to_f / VolunteerATron::Throttler.messages_per_rate_period.to_f
        end
      end

      def read_page(url)
        if VolunteerATron::Throttler.make_message!
          super(url)
          puts "Sleeping for #{VolunteerATron::Throttler::Tortoise.time_between_messages}"
          sleep(VolunteerATron::Throttler::Tortoise.time_between_messages)
        else
          VolunteerATron::Throttler.rate_limit_exceeded
          read_page(url)
        end
      end
    end
  end
end
