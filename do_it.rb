#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

location = ARGV[0] || 'london'

search_base = "http://github.com/search?type=Users&language=ruby&q=location:#{location}"
  
class VolunteerATron
  
  module Reader
    def read_page(url)
      puts "Fetching #{url}"
      open(url)
    end
  end
    
  module Cachet
    def cachet_initialized?
      @cachet_initialized
    end

    def initialize_cachet
      FileUtils.mkdir_p('cachet')
      @cachet_initialized = true
    end

    def read_page(url)
      initialize_cachet unless cachet_initialized?
      add_cachet(super(url), url) unless cached?(url)
      read_cached_page(url)
    end
    
    def cached?(url)
      File.exists?(cachet_form(url))
    end
    
    def read_cached_page(url)
      puts "Reading #{url} from cache"
      open(cachet_form(url))
    end
    
    def add_cachet(io_stream, from_url)
      puts "Writing #{from_url} to cache"
      File.open(cachet_form(from_url),'w+') do |f|
        f.write(io_stream.read)
      end
    end

    def cachet_form(url)
      "./cachet/#{url.downcase.gsub(/[^a-z0-9]/,'_')}.cachet"
    end
  end
  
  attr_accessor :users
  include VolunteerATron::Reader
  def initialize(with_caching = true)
    @users = []
    if with_caching
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

    @users += users.map do |user|
      user.xpath(%q{.//h2[@class='title']/a/@href}).text.gsub(/^\//,'')
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


volunteer_a_tron = VolunteerATron.new

volunteer_a_tron.fetch_all_users(search_base)

puts volunteer_a_tron.users

