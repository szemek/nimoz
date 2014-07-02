require 'pry'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'active_support'
require 'active_support/core_ext/object'
require 'colored'
require 'enumerator'

require_relative 'parser'

def base_url
  'http://nimoz.pl/pl/bazy-danych/wykaz-muzeow-w-polsce/baza-muzeow-w-polsce'
end

def page_url(page)
  "#{base_url}?page=#{page}"
end

from_page = 1
to_page = 18

museums = []

(from_page .. to_page).each do |page|
  doc = Nokogiri::HTML(open(page_url(page)))
  museums << Parser.new(doc).extract_data
end

museums.flatten!

museums.each do |museum|
  if museum[:name]
    puts museum[:name].blue
    puts museum[:voivodeship]
    puts museum[:district]
    puts museum[:commune]
    puts museum[:emails]
    puts museum[:webpages]
    puts museum[:phones]
  end
end
