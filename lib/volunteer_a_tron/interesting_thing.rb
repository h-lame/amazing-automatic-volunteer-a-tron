class VolunteerATron
  class InterestingThing
    attr_accessor :name
    attr_accessor :description
    attr_accessor :url
    attr_accessor :owner
    attr_accessor :watchers
    attr_reader :last_pushed

    def initialize(params)
      self.name = params[:name]
      self.description = params[:description]
      self.url = params[:homepage]
      self.fork =  params[:fork]
      self.last_pushed = params[:last_pushed]
      self.owner = params[:owner]
      self.watchers = params[:watchers].to_i
    end

    def fork?
      @fork
    end

    def own_work?
      !@fork
    end

    def fork=(new_fork)
      if new_fork.is_a?(TrueClass) || new_fork.is_a?(FalseClass)
        @fork = new_fork
      else
        @fork = ((new_fork.to_s || 'false').match(/true/i) != nil)
      end
    end

    def last_pushed=(new_last_pushed)
      if new_last_pushed.is_a?(Date)
        @last_pushed = new_last_pushed
      else
        #2009-04-17T04:13:45-07:00
        begin
          @last_pushed = Date.parse(new_last_pushed)
        rescue ArgumentError
          @last_pushed = nil
        end
      end
    end

    def popular?
      watchers >= VolunteerATron.popularity_threshold
    end

    def to_s
      "#{"#{owner.github_user_name}/" unless owner.nil?}#{@name}#{'(fork)' unless own_work?}: #{@description} (#{@url}) - #{last_pushed} - #{watchers} watcher#{"s" unless watchers == 1}"
    end

    def at_all_interesting?
      possibly_interesting? || a_bit_interesting?
    end

    def uninteresting?
      !at_all_interesting?
    end

    def really_interesting?
      possibly_interesting? && popular?
    end

    def possibly_interesting?
      own_work? && last_pushed && last_pushed > VolunteerATron.interesting_event_horizon
    end

    def a_bit_interesting?
      fork? && last_pushed && last_pushed > VolunteerATron.interesting_event_horizon
    end

    include Comparable
    def <=>(other_interesting_thing)
      if self.at_all_interesting?
        if other_interesting_thing.at_all_interesting?
          if self.really_interesting?
            if other_interesting_thing.really_interesting?
              default_ordering(other_interesting_thing)
            else
              -1
            end
          elsif self.possibly_interesting?
            if other_interesting_thing.really_interesting?
              1
            elsif other_interesting_thing.possibly_interesting?
              default_ordering(other_interesting_thing)
            else
              -1
            end
          else
            if other_interesting_thing.possibly_interesting?
              1
            else
              default_ordering(other_interesting_thing)
            end
          end
        else
          -1
        end
      else
        if other_interesting_thing.at_all_interesting?
          1
        else
          default_ordering(other_interesting_thing)
        end
      end
    end

    protected
      def default_ordering(other_interesting_thing)
        base_order =
          if self.watchers != other_interesting_thing.watchers
            other_interesting_thing.watchers <=> self.watchers
          elsif self.last_pushed && other_interesting_thing.last_pushed
            other_interesting_thing.last_pushed <=> self.last_pushed
          elsif self.last_pushed
            -1
          elsif other_interesting_thing.last_pushed
            1
          else
            0
          end
        base_order = other_interesting_thing.name <=> self.name if base_order == 0
        base_order
      end
  end
end