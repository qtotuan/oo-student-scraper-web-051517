require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    students = Nokogiri::HTML(html)

    students_array = []

    students.css(".student-card").each do |card|
      hash = {
        name: card.css(".student-name").text,
        location: card.css(".student-location").text,
        profile_url: card.css("a").attribute("href").value
      }
      students_array << hash
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    student = Nokogiri::HTML(html)
    urls = student.css(".social-icon-container a").map { |url| url.attribute("href").value}
    hash = {}

    urls.each do |url|
      if url.include?("linkedin")
        hash[:linkedin] = url
      elsif url.include?("github")
        hash[:github] = url
      elsif url.include?("twitter")
        hash[:twitter] = url
      else
        hash[:blog] = url
      end
    end

    hash[:profile_quote] = student.css(".profile-quote").text
    hash[:bio] = student.css(".bio-content p").text
    hash
  end

end

# Scraper.scrape_index_page('fixtures/student-site/index.html')
# Scraper.scrape_profile_page('fixtures/student-site/students/joe-burgess.html')
