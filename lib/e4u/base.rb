require 'rexml/document'

module E4U
  class Base
    include Enumerable

    def initialize
      @xml = @data = nil
    end

    def each
      data.each do |element|
        yield element
      end
      self
    end

    private

    @data = []
    def data
      return @data if @data
      @data = []
      xml.root.each_element('//e') do |element|
        hash = {}
        element.attributes.each{ |k,v| hash[k.to_sym] = v.to_s }
        if element.has_elements?
          hash[:desc] = element.get_text('desc').to_s if element.get_text('desc')
          hash[:ann] = element.get_text('ann').to_s if element.get_text('ann')
        end
        @data << emojinize(hash)
      end
      @data.recursive_freeze
    end

    def xml
      opt = 'rb'
      opt+= ':utf-8' unless RUBY_VERSION < '1.9'
      @xml ||= REXML::Document.new(File.open(path, opt){ |f| f.read })
    end

    def emojinize object
      object.extend Base::Emojinize
    end
  end

  module Base::Emojinize
    def emojiize
      Base::Emoji.new self
    end
  end

  class Base::Emoji
    def initialize attributes
      @attributes = attributes
      @attributes.each do |key, value|
        next if key =~ /\A(id|object_id|__(id|send)__)\z/
        self.class.class_eval("def #{key}; @attributes[:#{key}]; end", __FILE__, __LINE__)
      end
    end

    def alternate?
      !!(unicode =~ /\A>/)
    end

    def utf8
      hex = unicode.sub(/\A[\>\*\+]/, '')
      raise if hex.size == 0
      hex.split(/\+/, -1).map{ |ch| ch.hex }.pack('U')
    end

    def cp932
      hex = unicode.sub(/\A[\>\*\+]/, '')
      raise if hex.size == 0
      chr = hex.split(/\+/, -1).map{ |ch| unicode_to_cp932(ch.hex) }.pack('n')
      chr.force_encoding('CP932') if chr.respond_to? :force_encoding
      chr
    end
    alias :sjis :cp932

  end
end
