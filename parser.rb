class Parser
  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def extract_data
    data = []

    rows.each do |row|
      cells = row.css('td')

      case cells.count
      when 3 then data << extract_department(cells)
      when 4 then data << extract_museum(cells)
      else next
      end
    end

    data
  end

  private

  def table
    @table ||= document.css('table#lista_firm')
  end

  def rows
    @rows ||= table.css('tr').select{|row| row.content.strip.length > 0}
  end

  def extract_name(name)
    begin
      name.css('strong').first.content
    rescue NoMethodError
      ""
    end
  end

  def extract_location(location)
    voivodeship, district, commune = location.css('strong').map(&:content)

    {
      voivodeship: voivodeship,
      district: district,
      commune: commune
    }
  end

  def extract_department(cells)
    subname, address, extra = cells

    {
      subname: subname,
      address: address,
      extra: extra
    }
  end

  def extract_museum(cells)
    name, location, address, extra = cells

    {
      name: extract_name(name),
      location: extract_location(location),
      address: address,
      extra: extra
    }
  end
end
