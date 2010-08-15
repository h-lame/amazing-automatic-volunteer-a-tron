class VolunteerATron
  class InterestingThing
    attr_accessor :name
    attr_accessor :description
    attr_accessor :url
    def initialize(name, description, url)
      @name = name
      @description = description
      @url = url
    end
    
    def to_s
      "#{@name}: #{@description} (#{@url})"
    end
  end
end