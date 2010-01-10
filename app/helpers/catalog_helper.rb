module CatalogHelper
  def pretty_xml(xml)
    one_line_xml = xml.gsub(/\t/, '').gsub(/\n/, '')
    return h(one_line_xml) unless one_line_xml.start_with?('<')

    begin
      doc = REXML::Document.new(one_line_xml)
      formatter = REXML::Formatters::Pretty.new
      formatter.write(doc, str = '')
      return h(str)
    rescue
      return h(one_line_xml)
    end
  end
end
