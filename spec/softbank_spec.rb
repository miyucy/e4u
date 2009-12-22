# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe E4U::Softbank do
  before :all do
    @softbank = E4U.softbank
  end

  it "should include Enumerable" do
    @softbank.should be_kind_of Enumerable
  end

  it "should include E4U::Softbank::Emojinize" do
    @softbank.first.should be_kind_of E4U::Softbank::Emojinize
  end

  it "すべての要素に:unicodeをキーとしたデータはあること" do
    @softbank.each do |emj|
      emj.should have_key(:unicode)
    end
  end

  it "正しくデータを取得できること" do
    # <e name_ja="晴れ" number="81" unicode="E04A"/>
    emj = @softbank.find{ |e| e[:number] == '81' }
    emj[:unicode].should == 'E04A'
    emj[:name_ja].should == '晴れ'
    emj[:number].should == '81'
  end

  it "softbank_emojiでE4U::Softbank::Emojiが返ってくること" do
    emj = @softbank.find{ |e| e[:number] == '81' }
    emj.softbank_emoji.should be_instance_of E4U::Softbank::Emoji
  end

  describe E4U::Softbank::Emoji do
    before :all do
      @emj = @softbank.find{ |e| e[:number] == '81' }.softbank_emoji
    end

    it "utf8が返ってくること" do
      @emj.utf8.should == [0xE04A].pack('U')
    end

    it "sjisが返ってくること" do
      @emj.sjis.should == "\xF9\x8B"
    end

    it "alternate?が返ってくること" do
      @emj.alternate?.should be_false
    end
  end
end
