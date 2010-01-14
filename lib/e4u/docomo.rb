require 'e4u/base'

module E4U
  class DoCoMo < Base
    private

    def path
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data', 'docomo', 'carrier_data.xml'))
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
    def jis; nil; end
    def name_en; nil; end
    def name_ja; nil; end
    def unicode; nil; end

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
