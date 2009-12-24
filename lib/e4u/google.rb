require 'e4u/base'

module E4U
  class Google < Base
    private

    def path
      File.expand_path(File.join('..', '..', 'data', 'emoji4unicode.xml'), File.dirname(__FILE__))
    end

    def emojinize object
      object.extend Google::Emojinize
    end
  end

  module Google::Emojinize
    def docomo_emoji
      DoCoMo::Emoji.new :unicode => self[:docomo]
    end

    def kddi_emoji
      KDDI::Emoji.new :unicode => self[:kddi]
    end

    def kddiweb_emoji
      KDDIWeb::Emoji.new :unicode => self[:kddi]
    end

    def softbank_emoji
      Softbank::Emoji.new :unicode => self[:softbank]
    end

    def unicode_emoji
      Google::Emoji.new :unicode => self[:unicode]
    end

    def google_emoji
      Google::Emoji.new self
    end
  end

  class Google::Emoji < Base::Emoji
    def proposal?
      prop = respond_to?(:in_proposal) ? in_proposal : 'no'
      prop == 'yes'
    end

    def translate carrier
      case carrier.to_s.downcase
      when 'docomo'
        E4U.docomo.find{ |e| e[:unicode] == docomo }.docomo_emoji
      when 'kddi'
        E4U.kddi.find{ |e| e[:unicode] == kddi }.kddi_emoji
      when 'softbank'
        E4U.softbank.find{ |e| e[:unicode] == softbank }.softbank_emoji
      else
        raise ArgumentError
      end
    end
  end
end
