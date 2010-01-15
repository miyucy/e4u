require 'e4u/base'
require 'e4u/docomo'
require 'e4u/kddi'
require 'e4u/softbank'
require 'e4u/google'
require 'e4u/util'

module E4U
  def self.docomo
    @docomo ||= DoCoMo.new
  end

  def self.kddi
    @kddi ||= KDDI.new
  end

  def self.kddiweb
    self.kddi
  end

  def self.softbank
    @softbank ||= Softbank.new
  end

  def self.google
    @google ||= Google.new
  end
end
