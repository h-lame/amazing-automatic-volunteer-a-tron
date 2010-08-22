class VolunteerATron
  module Throttler
    module Hare
      def read_page(url)
        if VolunteerATron::Throttler.make_message!
          super(url)
        else
          VolunteerATron::Throttler.rate_limit_exceeded
          read_page(url)
        end
      end
    end
  end
end
