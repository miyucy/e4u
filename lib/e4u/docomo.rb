require 'e4u/base'

module E4U
  class DoCoMo < Base
    private

    def path
      File.expand_path(File.join('..', '..', 'data', 'docomo', 'carrier_data.xml'), File.dirname(__FILE__))
    end

    def emojinize object
      object.extend DoCoMo::Emojinize
    end
  end

  module DoCoMo::Emojinize
    def docomo_emoji
      DoCoMo::Emoji.new self
    end
  end

  class DoCoMo::Emoji < Base::Emoji
    private

    def unicode_to_cp932 octet
      return if octet < 0xE63E or octet > 0xE757

      if octet <= 0xE69B
        octet + 4705
      elsif octet <= 0xE6DA
        octet + 4772
      else
        octet + 4773
      end
    end
  end
end
