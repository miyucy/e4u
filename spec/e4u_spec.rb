# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "E4U" do
  it "インスタンスが返ってくること" do
    { :google   => E4U::Google,
      :docomo   => E4U::DoCoMo,
      :kddi     => E4U::KDDI,
      :kddiweb  => E4U::KDDI,
      :softbank => E4U::Softbank }.each{ |method, klass|
      E4U.method(method).call.should be_an_instance_of klass
    }
  end
end
