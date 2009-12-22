require 'e4u/base'

module E4U
  class KDDI < Base
    private

    def path
      File.expand_path(File.join('..', '..', 'data', 'kddi', 'carrier_data.xml'), File.dirname(__FILE__))
    end

    def emojinize object
      object.extend KDDI::Emojinize
    end
  end

  module KDDI::Emojinize
    def kddi_emoji
      KDDI::Emoji.new self
    end
    def kddiweb_emoji
      KDDIWeb::Emoji.new self
    end
  end

  class KDDI::Emoji < Base::Emoji
    private

    def unicode_to_cp932 octet
      if octet >= 0xE468 and octet <= 0xE5DF
        sjis = if octet <= 0xE4A6
          octet + 4568
        elsif octet <= 0xE523
          octet + 4569
        elsif octet <= 0xE562
          octet + 4636
        elsif octet <= 0xE5B4
          octet + 4637
        elsif octet <= 0xE5CC
          octet + 4656
        else
          octet + 3443
        end
      elsif octet >= 0xEA80 and octet <= 0xEB8E
        sjis = if octet <= 0xEAAB
          octet + 2259
        elsif octet <= 0xEAFA
          octet + 2260
        elsif octet <= 0xEB0D
          octet + 3287
        elsif octet <= 0xEB3B
          octet + 2241
        elsif octet <= 0xEB7A
          octet + 2308
        else
          octet + 2309
        end
      end
    end
  end

  class KDDIWeb < KDDI
  end

  class KDDIWeb::Emoji < KDDI::Emoji
    def utf8
      sjis.unpack('n*').map{ |char| char - 1792 }.pack('U')
    end
  end
end
