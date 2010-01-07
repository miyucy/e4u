# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe E4U::Google do
  before :all do
    @google = E4U.google
  end

  it "should include Enumerable" do
    @google.should be_kind_of Enumerable
  end

  it "should E4U::Google::Emojinize" do
    @google.first.should be_kind_of E4U::Google::Emojinize
  end

  it "すべての要素に:idをキーとしたデータはあること" do
    @google.each do |emj|
      emj.should have_key(:id)
    end
  end

  it "正しくデータを取得できること" do
    # つーかハッシュだし
    # <e docomo="E63E" google="FE000" id="000" kddi="E488" name="BLACK SUN WITH RAYS" softbank="E04A" unicode="2600">
    emj = @google.find{ |e| e[:id] == '000' }
    emj[:docomo].should == 'E63E'
    emj[:google].should == 'FE000'
    emj[:kddi].should == 'E488'
    emj[:name].should == 'BLACK SUN WITH RAYS'
    emj[:softbank].should == 'E04A'
    emj[:unicode].should == '2600'
  end

  it "docomo_emojiでE4U::DoCoMo::Emojiが返ってくること" do
    de = @google.find{ |e| e[:id] == '000' }.docomo_emoji
    de.should be_instance_of E4U::DoCoMo::Emoji
    de.utf8.should == [0xE63E].pack('U')
    de.sjis.dump.should == "\xF8\x9F".dump
  end

  it "DoCoMoの複合絵文字が返ってくること" do
    { '00F' => [[0xE63E, 0xE63F].pack('U*'), [0xF89F, 0xF8A0].pack('n*')],
      '4B8' => [[0xE669, 0xE6EF].pack('U*'), [0xF8CA, 0xF994].pack('n*')] }.each do |id, (utf8, sjis)|
      de = @google.find{ |e| e[:id] == id }.docomo_emoji
      de.utf8.should == utf8
      de.sjis.should == sjis
    end
  end

  it "kddi_emojiでE4U::KDDI::Emojiが返ってくること" do
    ke = @google.find{ |e| e[:id] == '000' }.kddi_emoji
    ke.should be_instance_of E4U::KDDI::Emoji
    ke.utf8.should == [0xE488].pack('U')
    ke.sjis.dump.should == "\xF6\x60".dump
  end

  it "KDDIの複合絵文字が返ってくること" do
    { '331' => [[0xE471, 0xE5B1].pack('U*'), [0xF649, 0xF7CE].pack('n*')], }.each do |id, (utf8, sjis)|
      de = @google.find{ |e| e[:id] == id }.kddi_emoji
      de.utf8.should == utf8
      de.sjis.should == sjis
    end
  end

  it "KDDI(Web)の複合絵文字が返ってくること" do
    { '331' => [[0xEF49, 0xF0CE].pack('U*'), [0xF649, 0xF7CE].pack('n*')], }.each do |id, (utf8, sjis)|
      de = @google.find{ |e| e[:id] == id }.kddiweb_emoji
      de.utf8.should == utf8
      de.sjis.should == sjis
    end
  end

  it "softbank_emojiでE4U::Softbank::Emojiが返ってくること" do
    se = @google.find{ |e| e[:id] == '000' }.softbank_emoji
    se.should be_instance_of E4U::Softbank::Emoji
    se.utf8.should == [0xE04A].pack('U')
    se.sjis.dump.should == "\xF9\x8B".dump
  end

  it "Softbankの複合絵文字が返ってくること" do
    { '00F' => [[0xE04A, 0xE049].pack('U*'), [0xF98B, 0xF98A].pack('n*')],
      '331' => [[0xE415, 0xE331].pack('U*'), [0xFB55, 0xF9D1].pack('n*')],
      '824' => [[0xE103, 0xE328].pack('U*'), [0xF743, 0xF9C8].pack('n*')], }.each do |id, (utf8, sjis)|
      de = @google.find{ |e| e[:id] == id }.softbank_emoji
      de.utf8.should == utf8
      de.sjis.should == sjis
    end
  end

  it "Unicode絵文字が返ってくること" do
    ue = @google.find{ |e| e[:id] == '000' }.unicode_emoji
    ue.utf8.should == [0x2600].pack('U')
  end

  it "Google絵文字が返ってくること" do
    ue = @google.find{ |e| e[:id] == '000' }.google_emoji
    ue.utf8.should == [0xFE000].pack('U')
  end

  describe E4U::Google::Emoji do
    before :all do
      @emj = @google.find{ |e| e[:id] == '000' }.google_emoji
    end

    it "docomoが返ってくること" do
      @emj.docomo.should == 'E63E'
      @emj.docomo.hex.should == 0xE63E
    end

    it "kddiが返ってくること" do
      @emj.kddi.should == 'E488'
      @emj.kddi.hex.should == 0xE488
    end

    it "softbankが返ってくること" do
      @emj.softbank.should == 'E04A'
      @emj.softbank.hex.should == 0xE04A
    end

    it "descが返ってくること" do
      @emj.desc.should be_an_instance_of String
      @emj.desc.should match(/clear weather/i)
    end

    it "translate(:docomo)でDoCoMo絵文字に変換できること" do
      de = @emj.translate :docomo
      de.utf8.should == [0xE63E].pack('U')
    end

    it "translate(:kddi)でKDDI絵文字に変換できること" do
      de = @emj.translate :kddi
      de.utf8.should == [0xE488].pack('U')
    end

    it "translate(:softbank)でSoftbank絵文字に変換できること" do
      de = @emj.translate :softbank
      de.utf8.should == [0xE04A].pack('U')
    end

    it "translateでArgumentErrorが起こること" do
      lambda{ @emj.translate :emobile }.should raise_error ArgumentError
    end

    it "proposal?が返ってくること" do
      @emj.proposal?.should be_false
    end

    it "text_fallbackが返ってくること" do
      @google.find{ |e| e[:google] == 'FE006' }.google_emoji.text_fallback.should == '[霧]'
    end

    it "utf8が返ってくること" do
      @emj.unicode.should == 'FE000'
      @emj.utf8.should == [0xFE000].pack('U')
    end

    it "should respond to in_proposal" do
      @google.each do |e|
        e.google_emoji.respond_to?(:in_proposal).should be_true
      end
    end

    it "should respond to text_fallback" do
      @google.each do |e|
        e.google_emoji.respond_to?(:text_fallback).should be_true
      end
    end

    it "should respond to text_repr" do
      @google.each do |e|
        e.google_emoji.respond_to?(:text_repr).should be_true
      end
    end

    it "should respond to desc" do
      @google.each do |e|
        e.google_emoji.respond_to?(:desc).should be_true
      end
    end

    it "alternate?が返ってくること" do
      @emj.alternate?.should be_false
    end
  end
end
