# Methods added to this helper will be available to all templates in the application.
require 'rexml/formatters/pretty'
require 'rexml/document'

module ApplicationHelper  
  def flash_message
    messages = flash.map do |message_type, message|
      render(:partial => 'partials/flash', :locals =>
              {:message_type => message_type, :message => message}) unless message.blank?
    end

    if @error_message
      messages << render(:partial => 'partials/flash', :locals =>
              {:message_type => :error, :message => @error_message}) unless @error_message.blank?
    end

    if @info_message
      messages << render(:partial => 'partials/flash', :locals =>
              {:message_type => :message, :message => @info_message}) unless @info_message.blank?
    end
    messages.join('')
  end

  def date_time(date)
    if date then
      date.strftime("%Y.%m.%d")
    else
      "Not yet"
    end
  end

  def pretty_xml_format(xml)
    Syntax::Convertors::HTML.for_syntax('xml').convert(xml)
  end
end
