require "proquint/version"

# A Proquint is a readable, spellable, pronouncable representation of a
# number. In Ruby, a proquint is a string, such as "badab-lufiv", which
# represents the number 0x407d92 (or 4226450 in decimal).
#
# See http://arxiv.org/html/0901.4016 for more details.
#
# The main API is provided by `encode` and `decode`, the former of which takes
# a number, or an array of words (unsigned 16-bit integers) to make a
# proquint, and the latter of which takes a proquint and returns an array of
# words. There are also some convenience methods for getting a complete number
# from an array of words, for getting an array of words from a number, and for
# converting between dotted-decimal IP-addresses and hex IP addresses.
module Proquint
  CONSONANTS = %w[b d f g h j k l m n p r s t v z]
  VOWELS = %w[a i o u]
  REVERSE = {}
  CONSONANTS.each_with_index { |c, i| REVERSE[c] = i }
  VOWELS.each_with_index { |c, i| REVERSE[c] = i }
  DQUAD_PATTERN = /^(\d{1,3}).(\d{1,3}).(\d{1,3}).(\d{1,3})$/
  HEX_PATTERN = /^x(\h+)$/

  def str2words(string)
    string.bytes
  end

  def dquad2hex(dquad)
    if dquad =~ DQUAD_PATTERN
      i = (($1.to_i << 24) + ($2.to_i << 16) + ($3.to_i << 8) + $4.to_i)
      "x#{i.to_s(16)}"
    else
      raise ArgumentError.new("Invalid dotted quad")
    end
  end

  def hex2dquad(hex)
    if hex =~ HEX_PATTERN
      i = $1.to_i(16)
      [(i & 0xff000000) >> 24, (i & 0xff0000) >> 16, (i & 0xff00) >> 8, i & 0xff].join('.')
    else
      raise ArgumentError.new("Invalid hex address")
    end
  end

  def num2words(num)
    words = [num & 0xffff]
    while num > 0xffff
      num >>= 16
      words.unshift(num & 0xffff)
    end
    words
  end

  def words2num(words)
    num = words.shift || 0
    until words.empty?
      num <<= 16
      num += words.shift
    end
    num
  end

  # Convert a string, number or array of uint16s to a proquint
  def encode(i, sep = "-")
    case i
      when Fixnum
        raise ArgumentError.new("Can't encode negative numbers") if i < 0
        return encode(num2words(i)) if i > 0xffff
        CONSONANTS[(i & 0xf000) >> 12] +
          VOWELS[(i & 0xc00) >> 10] +
          CONSONANTS[(i & 0x3c0) >> 6] +
          VOWELS[(i & 0x30) >> 4] +
          CONSONANTS[i & 0xf]
      when Array then i.map { |x| encode(x) }.join(sep)
      when DQUAD_PATTERN then encode(dquad2hex(i)[1..-1].to_i(16))
      when String then encode(str2words(i))
      else raise ArgumentError.new("Can't encode #{i}")
    end
  end

  # Convert a proquint to an array of numbers (between 0 and 0xffff)
  def decode(s, sep = "-")
    s.split(sep).map do |p|
      p = p.downcase
      raise ArgumentError.new("Invalid proquint") unless p.bytes.length == 5
      (REVERSE[p[0]]   << 12) +
        (REVERSE[p[1]] << 10) +
        (REVERSE[p[2]] << 6) +
        (REVERSE[p[3]] << 4) +
        (REVERSE[p[4]])
    end
  end

  # Convert a proquint to a number
  def quint2num(s, sep = "-")
    words2num(decode(s))
  end
  extend self
end
