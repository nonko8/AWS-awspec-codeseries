#!/usr/bin/env ruby
#
# Definition定義に記載されたIPアドレスをSecgroupfilieに適用する

require './spec/definitions'

class Hash
  # ネストされたHashの葉要素の値を取り出す
  # 戻り値は葉要素までのkeyをドットでつないだものをkey、葉要素をvalueとしたHash
  # @return Hash
  def leaves_with_key(*keys)
    leaves = {}
    self.each_pair do |k,v|
      v.is_a?(Hash) ?
        leaves.merge!(v.leaves_with_key(keys,k)) :
        leaves[[keys,k].flatten.join('.')] = v
    end
    leaves
  end
end

ip_list = Definitions.ip.to_h.leaves_with_key

Dir.glob("./spec/**/*_spec.rb") do |filename|
  puts "#{filename}"
  File.open(filename, "r+") do |f|
    dsl = f.read
    ip_list.each_pair do |k,v|
      dsl.gsub!("'#{v}'", "Definitions.ip.#{k}")
    end
  
    f.rewind
    f.puts(dsl)
  end
end
