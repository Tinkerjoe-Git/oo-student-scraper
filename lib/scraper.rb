require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
      students << {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.search("a").first["href"]
      }
    end
    students

  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    scraped_student = {}
    social_info = doc.css(".social-icon-container").search("a").collect { |s| s.attributes["href"].value }
    social_info.detect do |s|
      scraped_student[:twitter] = s if s.include?("twitter")
      scraped_student[:linkedin] = s if s.include?("linkedin")
      scraped_student[:github] = s if s.include?("github")
      scraped_student[:blog] = s if !(s.include?("twitter") || s.include?("linkedin") || s.include?("github"))
    end

    scraped_student[:profile_quote] = doc.css("div.profile-quote").text
    scraped_student[:bio] = doc.css(".description-holder").search("p").text
    scraped_student
  end

  


end

