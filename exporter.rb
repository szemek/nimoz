require 'csv'

class Exporter
  attr_accessor :collection, :fields

  def initialize(collection, fields)
    @collection = collection
    @fields = fields
  end

  def to_csv(options = {})
    CSV.generate(options.merge(col_sep: "\t")) do |csv|
      csv << fields
      collection.each do |item|
        csv << item.values_at(*fields)
      end
    end
  end
end
