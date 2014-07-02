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
      { name: name.css('strong').first.content }
    rescue NoMethodError
      { name: "" }
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

  def extract_emails(address)
    emails = address.css("a[href^='mailto']").map(&:content)

    if emails.present?
      {emails: emails}
    else
      {}
    end
  end

  def extract_webpages(address)
    webpages = address.css("a[href^='http']").map(&:content)

    if webpages.present?
      {webpages: webpages}
    else
      {}
    end
  end

  def extract_phones(address)
    phones = address.enum_for(:traverse).select do |element|
      element.is_a?(Nokogiri::XML::Text) && element.content.include?("tel")
    end.map(&:content).map(&:strip)

    if phones.present?
      {phones: phones}
    else
      {}
    end
  end

  def extract_museum(cells)
    name, location, address, extra = cells

    museum = extract_name(name)
      .merge(extract_location(location))
      .merge(extract_emails(address))
      .merge(extract_webpages(address))
      .merge(extract_phones(address))

    museum
  end
end
