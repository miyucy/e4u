# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe E4U::KDDI do
  before :all do
    @kddi = E4U.kddi
  end

  it "should include Enumerable" do
    @kddi.should be_kind_of Enumerable
  end

  it "should include E4U::KDDI::Emojinize" do
    @kddi.first.should be_kind_of E4U::KDDI::Emojinize
  end

  it "E4U.kddiとE4U.kddiwebは同じものを返すこと" do
    E4U.kddi.should == E4U.kddiweb
  end

  it "すべての要素に:unicodeをキーとしたデータはあること" do
    @kddi.each do |emj|
      emj.should have_key(:unicode)
    end
  end

  it "正しくデータを取得できること" do
    # <e name_ja="太陽" number="44" unicode="E488"/>
    emj = @kddi.find{ |e| e[:number] == '44' }
    emj[:unicode].should == 'E488'
    emj[:name_ja].should == '太陽'
    emj[:number].should == '44'
  end

  it "kddi_emojiでE4U::KDDI::Emojiが返ってくること" do
    emj = @kddi.find{ |e| e[:number] == '44' }
    emj.kddi_emoji.should be_instance_of E4U::KDDI::Emoji
  end

  it "kddiweb_emojiでE4U::KDDIWeb::Emojiが返ってくること" do
    emj = @kddi.find{ |e| e[:number] == '44' }
    emj.kddiweb_emoji.should be_instance_of E4U::KDDIWeb::Emoji
  end

  describe E4U::KDDI::Emoji do
    before :all do
      @emj = @kddi.find{ |e| e[:number] == '44' }.kddi_emoji
    end

    it "unicodeが返ってくること" do
      @emj.unicode.should == 'E488'
    end

    it "utf8が返ってくること" do
      @emj.utf8.should == [0xE488].pack('U')
    end

    it "sjisが返ってくること" do
      @emj.sjis.dump.should == "\xF6\x60".dump
    end

    it "alternate?が返ってくること" do
      @emj.alternate?.should be_false
    end
  end

  it "E4U.kddiから取得した絵文字にfallback_textがないこと" do
    @kddi.each do |data|
      emoji = data.kddi_emoji
      emoji.fallback_text.should be_nil
      emoji.should_not be_fallback
    end
  end

  describe E4U::KDDIWeb::Emoji do
    before :all do
      @emj = @kddi.find{ |e| e[:number] == '44' }.kddiweb_emoji
    end

    it "unicodeが変化していること" do
      @emj.unicode.should == 'EF60'
    end

    it "utf8が返ってくること" do
      @emj.utf8.should == [0xEF60].pack('U')
    end

    it "sjisが返ってくること" do
      @emj.sjis.dump.should == "\xF6\x60".dump
    end

    it "alternate?が返ってくること" do
      @emj.alternate?.should be_false
    end
  end
end
