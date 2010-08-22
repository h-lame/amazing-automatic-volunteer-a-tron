require 'volunteer_a_tron/throttler/hare'
require 'volunteer_a_tron/throttler/tortoise'
require 'time'

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
        initialize_rate_period if @rate_period_start.nil?
        @rate_period_start
      end

      def rate_period_ends_at
        rate_period_started_at + rate_period
      end

      def start_new_rate_period
        @rate_period_start = Time.now
        puts "Starting new rate_period at #{@rate_period_start}"
        @messages_this_period = 0
        record_run_info
      end

      def can_make_message?
        if rate_period_ends_at < Time.now
          start_new_rate_period
        end
        puts "#{@messages_this_period} < #{messages_per_rate_period} (#{@messages_this_period < messages_per_rate_period})"
        @messages_this_period < messages_per_rate_period
      end

      def make_message!
        if can_make_message?
          @messages_this_period += 1
          record_run_info
        else
          false
        end
      end

      def rate_limit_exceeded
        puts "Rate Limit exceeded, sleeping until #{VolunteerATron::Throttler.rate_period_ends_at}"
        sleep(VolunteerATron::Throttler.rate_period_ends_at - Time.now)
      end

      def initialize_rate_period
        if File.exists?('.throttler_last_period')
          puts "Reading previous run information"
          the_past = File.read('.throttler_last_period')
          begin
            time, message_count, = the_past.split("\n")
            @rate_period_start = Time.parse(time)
            @messages_this_period = message_count.to_i
            if rate_period_ends_at < Time.now
              puts "It's more than a single rate period ago #{@rate_period_start}.  Starting a fresh one."
              start_new_rate_period
            end
          rescue ArgumentError
            puts "Assuming this is a fresh run, previous run information was bunk: #{the_past}"
            start_new_rate_period
          end
        else
          start_new_rate_period
        end
      end

      def record_run_info
        File.open('.throttler_last_period', 'w+') do |f|
          f.write("#{@rate_period_start.to_s}\n#{@messages_this_period}\n")
        end
      end
    end
  end
end
