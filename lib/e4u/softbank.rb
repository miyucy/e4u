require 'e4u/base'

module E4U
  class Softbank < Base
    private

    def path
      File.expand_path(File.join('..', '..', 'data', 'softbank', 'carrier_data.xml'), File.dirname(__FILE__))
    end

    def emojinize object
      object.extend Softbank::Emojinize
    end
  end

  module Softbank::Emojinize
    def softbank_emoji
      Softbank::Emoji.new self
    end
  end

  class Softbank::Emoji < Base::Emoji
    def name_ja; nil end
    def number; nil end
    def unicode; nil end

    private

    def unicode_to_cp932 octet
      return if octet < 0xE001 or octet > 0xE55A

      page = (octet >> 8) & 7
      sjisHi = [0xF9, 0xF7, 0xF7, 0xF9, 0xFB, 0xFB][page]
      sjisLo = [0x40, 0x40, 0xA0, 0xA0, 0x40, 0xA0][page] + (octet & 0x7F)
      sjisLo += 1 if sjisLo > 0x7E and sjisLo < 0xA1
      sjisHi << 8 | sjisLo
    end
  end
end
