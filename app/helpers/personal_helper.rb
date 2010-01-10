module PersonalHelper
  def md_xml(md)
    f = SimpleHtmlMetadataFormatter.new
    f.format(md)
  end

  def md_nice(md)
    f = XsltMetadataFormatter.new
    f.set_block 'Item', '/MD_Metadata', 'fileIdentifier/CharacterString'
    f.add_content 'Standard', 'metadataStandardName/CharacterString'
    f.add_content 'Description', '//abstract/CharacterString'
    f.format(md)
  end
end
