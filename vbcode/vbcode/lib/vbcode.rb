require "vbcode/version"

module VBCode
  extend self

  def encode(n)
    bytes = []
    loop do
      bytes.unshift n % 128
      if n < 128
        break
      else
        n = n / 128
      end
    end
    bytes[-1] += 128
    bytes.pack("C*")
  end

  def decode(bytes)
    nums = []
    n = 0
    bytes.unpack("C*").each do |c|
      if c < 128
        n = n * 128 + c
      else
        nums << n * 128 + (c - 128)
        n = 0
      end
    end
    nums
  end
end
