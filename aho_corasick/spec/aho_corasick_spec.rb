require "spec_helper"

RSpec.describe AhoCorasick do
  it "shor string" do
    ac = AhoCorasick::AhoCorasickTree.new(%w{he she his hers})
    expect(ac.match("ahishers")).to eq({
      1 => ["his"],
      3 => ["she"],
      4 => ["he", "hers"]
    })
  end

  it "long string" do
    keywords = open('spec/keyword.utf8.uniq.txt') {|f| f.read}
      .split(/\n/)
      .map {|line| line.chomp}
    ac = AhoCorasick::AhoCorasickTree.new(keywords)
    text = <<EOS;
今日は天気がよかったので、近くの海まで愛犬のしなもんと一緒にお散歩。写真は海辺を楽しそうに歩くしなもん。そのあとついでにお買い物にも行ってきました。「はてなの本」を買ったので、はてなダイアリーの便利な商品紹介ツール「はまぞう」を使って紹介してみるよ。とてもおもしろいのでみんなも読んでみてね。
EOS
    expect(ac.match(text)).to match({0=>["今日"], 3=>["天気"], 22=>["しなもん"], 31=>["散歩"], 34=>["写真"], 37=>["海辺"], 47=>["しなもん"], 75=>["はてな", "はてなの本"], 88=>["はてな", "はてなダイアリ", "はてなダイアリー"], 91=>["ダイアリー"], 100=>["商品"], 108=>["はまぞう"], 128=>["おもしろい"]})
  end
end
