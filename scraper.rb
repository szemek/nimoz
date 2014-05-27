require 'pry'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'active_support'
require 'active_support/core_ext/object'
require 'colored'

def page_url(page)
  base_url = 'http://nimoz.pl/pl/bazy-danych/wykaz-muzeow-w-polsce/baza-muzeow-w-polsce'

  "#{base_url}?page=#{page}"
end

from_page = 1
to_page = 18

(from_page .. to_page).each do |page|
  doc = Nokogiri::HTML(open(page_url(page)))
end
