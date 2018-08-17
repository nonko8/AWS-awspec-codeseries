require 'ostruct'
require 'yaml'

# create Openstruct Object from nested Hash
# http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash/#.VDXhQSl_vVg

class DeepStruct < OpenStruct
  def initialize(hash=nil)
    @table = {}
    @hash_table = {}

    if hash
      hash.each do |k,v|
        @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
        @hash_table[k.to_sym] = v

        new_ostruct_member(k)
      end
    end
  end

  def to_h
    @hash_table
  end

end
class Definitions
  def self.ip
    filepath = File.expand_path('address_list.yml', File.dirname(__FILE__))
    DeepStruct.new(YAML.load(File.read(filepath)).to_h)
  end
end

