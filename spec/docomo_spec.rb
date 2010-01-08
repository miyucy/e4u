# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe E4U::DoCoMo do
  before :all do
    @docomo = E4U.docomo
  end

  it "should include Enumerable" do
    @docomo.should be_kind_of Enumerable
  end

  it "should include E4U::DoCoMo::Emojinize" do
    @docomo.first.should be_kind_of E4U::DoCoMo::Emojinize
  end

  it "すべての要素に:unicodeをキーとしたデータはあること" do
    @docomo.each do |emj|
      emj.should have_key(:unicode)
    end
  end

  it "正しくデータを取得できること" do
    # <e jis="7541" name_en="Fine" name_ja="晴れ" unicode="E63E"/>
    emj = @docomo.find{ |e| e[:name_en] == 'Fine' }
    emj[:unicode].should == 'E63E'
    emj[:name_en].should == 'Fine'
    emj[:name_ja].should == '晴れ'
    emj[:jis].should == '7541'
  end

  it "docomo_emojiでE4U::DoCoMo::Emojiが返ってくること" do
    emj = @docomo.find{ |e| e[:name_en] == 'Fine' }
    emj.docomo_emoji.should be_instance_of E4U::DoCoMo::Emoji
  end

  it "E4U.docomoから取得した絵文字にfallback_textがないこと" do
    @docomo.each do |data|
      emoji = data.docomo_emoji
      emoji.fallback_text.should be_nil
      emoji.should_not be_fallback
    end
  end

  describe E4U::DoCoMo::Emoji do
    before :all do
      @emj = @docomo.find{ |e| e[:unicode] == 'E63E' }.docomo_emoji
    end

    it "utf8が返ってくること" do
      @emj.utf8.should == [0xE63E].pack('U')
    end

    it "sjisが返ってくること" do
      @emj.sjis.dump.should == "\xF8\x9F".dump
    end

    it "alternate?が返ってくること" do
      @emj.alternate?.should be_false
    end
  end
end
