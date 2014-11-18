# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/i18n"

describe LogStash::Filters::I18n do
  

  describe "transliterate" do
    config <<-CONFIG
      filter {
        i18n {
          transliterate => [ "transliterateme" ]
        }
      }
    CONFIG

    event = {
      "transliterateme" => [ "Ærøskøbing" ]
    }

    sample event do
      insist { subject["transliterateme"] } == [ "AEroskobing" ]
    end
  end
end
