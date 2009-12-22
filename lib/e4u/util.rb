# -*- coding: utf-8 -*-
class Object
  def recursive_freeze
    case self
    when Hash
      self.each_value{ |e| e.recursive_freeze }
    when Array
      self.each{ |e| e.recursive_freeze }
    end
    self.freeze
  end
end

if __FILE__ == $PROGRAM_NAME
  a = Array.new(10){|i| {:c => "#{i}"} }

  # 本当は Object.freeze! のがよかったなぁ
  a.recursive_freeze

  puts a.frozen?
  a.each do |b|
    puts b.frozen?
    puts b[:c].frozen?
  end
end
