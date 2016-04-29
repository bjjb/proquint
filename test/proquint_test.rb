require 'test_helper'
require 'proquint'

describe Proquint do
  it "can convert dotted quads to hex" do
    Proquint.dquad2hex('127.0.0.1').must_equal 'x7f000001'
    Proquint.dquad2hex('123.123.123.123').must_equal 'x7b7b7b7b'
  end

  it "can convert hex to dotted quad" do
    Proquint.hex2dquad('x7f000001').must_equal '127.0.0.1'
    Proquint.hex2dquad('x7b7b7b7b').must_equal '123.123.123.123'
  end

  it "can split large numbers into unsigned 16-bit integers" do
    Proquint.num2words(0x1).must_equal [1]
    Proquint.num2words(0x1111).must_equal [0x1111]
    Proquint.num2words(0x10000).must_equal [1, 0]
    Proquint.num2words(0x10001).must_equal [1, 1]
    Proquint.num2words(0xa000a000a).must_equal [10, 10, 10]
  end

  it "can combine an array or unsigned 16-bit integers" do
    Proquint.words2num([1]).must_equal 1
    Proquint.words2num([1, 1]).must_equal 0x10001
    Proquint.words2num([1, 0]).must_equal 0x10000
    Proquint.words2num([10, 10, 10]).must_equal 0xa000a000a
  end

  it "can encode numbers" do
    Proquint.encode(0).must_equal 'babab'
    Proquint.encode(0x10000).must_equal 'babad-babab'
    Proquint.encode(0x7f000001).must_equal 'lusab-babad'
    Proquint.encode(1234567890123456).must_equal 'babah-karij-gufap-rorab'
    Proquint.encode(0x1234567890abcdef).must_equal 'damuh-jinum-nafor-suloz'
  end

  it "can encode strings" do
    Proquint.encode("Hello").must_equal 'badam-badoj-bados-bados-badoz'
  end

  it "can encode and decode IP addresses" do
    Proquint.encode("192.168.1.1").must_equal "safom-bahad"
    Proquint.decode("safom-bahad").must_equal [49320, 257]
  end

  it "can decode proquints" do
    Proquint.decode('babab').must_equal [0]
    Proquint.decode('babad-babab').must_equal [1, 0]
    Proquint.decode('lusab-babad').must_equal [0x7f00, 1]
  end
end
