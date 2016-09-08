# encoding: utf-8
require "i18n"
require "logstash/filters/base"
require "logstash/namespace"


# The i18n filter allows you to remove special characters
# from a field
class LogStash::Filters::I18n < LogStash::Filters::Base
  config_name "i18n"
  milestone 0

  # Replaces non-ASCII characters with an ASCII approximation, or
  # if none exists, a replacement character which defaults to `?`
  #
  # Example:
  # [source,ruby]
  #     filter {
  #       i18n {
  #          transliterate => ["field1", "field2"]
  #       }
  #     }
  config :transliterate, :validate => :array

  public
  def register
  end # def register

  public
  def filter(event)

    transliterate(event) if @transliterate

    filter_matched(event)
  end # def filter

  private
  def transliterate(event)
    @transliterate.each do |field|
      value = event.get(field)
      if value.is_a?(Array)
        event.set(field, value.map { |v| I18n.transliterate(v).encode('UTF-8') })
      elsif value.is_a?(String)
        event.set(field, I18n.transliterate(value.encode('UTF-8')))
      else
        @logger.debug("Can't transliterate something that isn't a string",
                      :field => field, :value => value)
      end
    end
  end # def transliterate

end # class LogStash::Filters::I18n
