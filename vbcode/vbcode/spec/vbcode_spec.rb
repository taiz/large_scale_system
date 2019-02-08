require "spec_helper"

RSpec.describe VBCode do
  describe "encode" do
    {
      1 => '10000001',
      5 => '10000101',
      127 => '11111111',
      128 => '00000001' + '10000000',
      129 => '00000001' + '10000001',
    }.each do |src, dst|
      it "#{src} should be encoded #{dst}" do
        expect(VBCode.encode(src).unpack("B*")[0]).to eq dst
      end
    end
  end

  describe "decode" do
    (1..1000).each do |v|
      it "decoding #{v}" do
        expect(VBCode.decode(VBCode.encode(v))[0]).to eq v
      end
    end
  end
end
