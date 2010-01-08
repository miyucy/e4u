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
      DoCoMo::Emoji.new attribute_with_fallback_text(:docomo)
    end

    def kddi_emoji
      KDDI::Emoji.new attribute_with_fallback_text(:kddi)
    end

    def kddiweb_emoji
      KDDIWeb::Emoji.new attribute_with_fallback_text(:kddi)
    end

    def softbank_emoji
      Softbank::Emoji.new attribute_with_fallback_text(:softbank)
    end

    def unicode_emoji
      Google::Emoji.new self
    end

    def google_emoji
      Google::Emoji.new self.merge(:unicode => self[:google])
    end

    private

    def attribute_with_fallback_text type
      attributes = { :unicode => self[type] }
      unless attributes[:unicode]
        attributes[:fallback_text]   = self[:text_fallback]
        attributes[:fallback_text] ||= self[:text_repr]
        attributes[:fallback_text] ||= [0x3013].pack('U')
      end
      attributes
    end
  end

  class Google::Emoji < Base::Emoji
    def docomo; nil; end
    def glyphRefID; nil; end
    def google; nil; end
    def id; nil; end
    def img_from; nil; end
    def in_proposal; nil; end
    def kddi; nil; end
    def name; nil; end
    def oldname; nil; end
    def softbank; nil; end
    def text_fallback; nil; end
    def text_repr; nil; end
    def unicode; nil; end

    def proposal?
      in_proposal == 'yes'
    end

    def translate carrier
      case carrier.to_s.downcase
      when 'docomo'
        emoji = E4U.docomo.find{ |e| e[:unicode] == docomo }
        return emoji.docomo_emoji if emoji
        E4U.google.find{ |e| e[:google] == google }.docomo_emoji

      when 'kddi'
        emoji = E4U.kddi.find{ |e| e[:unicode] == kddi }
        return emoji.kddi_emoji if emoji
        E4U.google.find{ |e| e[:google] == google }.kddi_emoji

      when 'softbank'
        emoji = E4U.softbank.find{ |e| e[:unicode] == softbank }
        return emoji.softbank_emoji if emoji
        E4U.google.find{ |e| e[:google] == google }.softbank_emoji

      else
        raise ArgumentError
      end
    end
  end
end
