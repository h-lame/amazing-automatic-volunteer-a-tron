require 'volunteer_a_tron/throttler/hare'
require 'volunteer_a_tron/throttler/tortoise'

class VolunteerATron
  module Throttler
    class << self
      def rate_period
        60 * 60
      end

      def messages_per_rate_period
        60
      end

      def rate_period_started_at
        start_new_rate_period if @rate_period_start.nil?
        @rate_period_start
      end

      def rate_period_ends_at
        rate_period_started_at + rate_period
      end

      def start_new_rate_period
        @rate_period_start = Time.now
        @messages_this_period = 0
      end

      def can_make_message?
        if rate_period_ends_at >= Time.now
          start_new_rate_period
        end
        @messages_this_period < messages_per_rate_period
      end

      def make_message!
        if can_make_message?
          @messages_this_period += 1
        else
          false
        end
      end

      def rate_limit_exceeded
        puts "Rate Limit exceeded, sleeping until #{VolunteerATron::Throttler.rate_period_ends_at}"
        sleep(Time.now - VolunteerATron::Throttler.rate_period_ends_at)
      end
    end
  end
end
