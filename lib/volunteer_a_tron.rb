require 'volunteer_a_tron/reader'
require 'volunteer_a_tron/cachet'
require 'volunteer_a_tron/volunteer'
require 'volunteer_a_tron/config'
require 'nokogiri'

class VolunteerATron  
  attr_accessor :users
  include VolunteerATron::Reader
  def initialize
    @users = []
    if VolunteerATron.use_caching?
      self.class.class_eval do
        include VolunteerATron::Cachet
      end
    end
  end

  def fetch_all_users(starting_from)
    next_page = starting_from
    loop do
      next_page = find_volunteers_from(next_page)
      break if next_page.nil?
    end
    @users
  end

  def find_volunteers_from(url)
    search_page = Nokogiri::HTML(read_page(url))

    get_users_from_search(search_page)

    return get_next_page_from_search(search_page)
  end

  def get_users_from_search(search_page)
    user_elems = search_page.xpath(%q{id('code_search_results')//div[@class='result']})

    @users += user_elems.map do |user|
      VolunteerATron::Volunteer.new(user.xpath(%q{.//h2[@class='title']/a/@href}).text.gsub(/^\//,''))
    end
  end

  def get_next_page_from_search(search_page)
    pagination = search_page.xpath(%q{id('code_search_results')//div[@class='pagination']})
    current_page = pagination.xpath(%q{.//span[@class='current']})

    next_page = pagination.xpath(%q{.//span[@class='current']/following-sibling::a[@class='pager_link']/@href}).first
    next_page = next_page.text unless next_page.nil?
    return next_page
  end
end
