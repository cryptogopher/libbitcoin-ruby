# -*- coding: ascii-8bit -*-
describe Bitcoin::URI do
  it 'parses http uri' do
    test = "http://github.com/libbitcoin?good=true#nice"
    parsed = described_class.new
    expect(parsed.decode(test)).to be true

    expect(parsed.has_authority).to be true
    expect(parsed.has_query).to be true
    expect(parsed.has_fragment).to be true

    expect(parsed.scheme).to eq "http"
    expect(parsed.authority).to eq "github.com"
    expect(parsed.path).to eq "/libbitcoin"
    expect(parsed.query).to eq "good=true"
    expect(parsed.fragment).to eq "nice"

    expect(parsed.encoded).to eq test
  end

  it 'parses messy uri' do
    test = "TEST:%78?%79#%7a"
    parsed = described_class.new
    expect(parsed.decode(test)).to be true

    expect(parsed.has_authority).to be false
    expect(parsed.has_query).to be true
    expect(parsed.has_fragment).to be true

    expect(parsed.scheme).to eq "test"
    expect(parsed.path).to eq "x"
    expect(parsed.query).to eq "y"
    expect(parsed.fragment).to eq "z"

    expect(parsed.encoded).to eq test
  end

  it 'parses scheme' do
    parsed = described_class.new
    expect(parsed.decode("")).to be false
    expect(parsed.decode(":")).to be false
    expect(parsed.decode("1:")).to be false
    expect(parsed.decode("%78:")).to be false

    expect(parsed.decode("x:")).to be true
    expect(parsed.scheme).to eq "x"

    expect(parsed.decode("x::")).to be true
    expect(parsed.scheme).to eq "x"
    expect(parsed.path).to eq ":"
  end

  it 'parses non strict uri' do
    parsed = described_class.new
    expect(parsed.decode("test:?テスト")).to be false

    expect(parsed.decode("test:テスト", false)).to be true
    expect(parsed.scheme).to eq "test"
    expect(parsed.path).to eq "テスト"
  end

  it 'parses authority' do
    parsed = described_class.new
    expect(parsed.decode("test:/")).to be true
    expect(parsed.has_authority).to be false
    expect(parsed.path).to eq "/"

    expect(parsed.decode("test://")).to be true
    expect(parsed.has_authority).to be true
    expect(parsed.authority).to eq ""
    expect(parsed.path).to eq ""

    expect(parsed.decode("test:///")).to be true
    expect(parsed.has_authority).to be true
    expect(parsed.authority).to eq ""
    expect(parsed.path).to eq "/"

    expect(parsed.decode("test:/x//")).to be true
    expect(parsed.has_authority).to be false
    expect(parsed.path).to eq "/x//"

    expect(parsed.decode("ssh://git@github.com:22/path/")).to be true
    expect(parsed.has_authority).to be true
    expect(parsed.authority).to eq "git@github.com:22"
    expect(parsed.path).to eq "/path/"
  end

  it 'encodes query' do
    uri = described_class.new
    query_map = { 'x':'y', 'z':'', :abc => :de, 2 => 1.19 }

    expect(uri.has_query).to be false
    uri.encode_query(query_map)
    expect(uri.has_query).to be true
    expect(uri.query).to include('x=y', 'z', 'abc=de', '2=1.19')
    expect(uri.query.length).to eq 19
  end

  it 'parses query' do
    parsed = described_class.new
    expect(parsed.decode("test:#?")).to be true
    expect(parsed.has_query).to be false

    expect(parsed.decode("test:?&&x=y&z")).to be true
    expect(parsed.has_query).to be true
    expect(parsed.query).to eq "&&x=y&z"

    map = parsed.decode_query
    expect(map[""]).not_to be nil
    expect(map["x"]).not_to be nil
    expect(map["z"]).not_to be nil
    expect(map["y"]).to be nil

    expect(map[""]).to eq ""
    expect(map["x"]).to eq "y"
    expect(map["z"]).to eq ""
  end

  it 'parses fragment' do
    parsed = described_class.new
    expect(parsed.decode("test:?")).to be true
    expect(parsed.has_fragment).to be false

    expect(parsed.decode("test:#")).to be true
    expect(parsed.has_fragment).to be true
    expect(parsed.fragment).to eq ""

    expect(parsed.decode("test:#?")).to be true
    expect(parsed.has_fragment).to be true
    expect(parsed.fragment).to eq "?"
  end

  it 'encodes complex uri' do
    out = described_class.new
    # TODO: convert set_XXX methods to Ruby setters (?)
    out.set_scheme("test")
    out.set_authority("user@hostname")
    out.set_path("/some/path/?/#")
    out.set_query("tacos=yummy")
    out.set_fragment("good evening")
    expect(out.encoded).to eq \
      "test://user@hostname/some/path/%3F/%23?tacos=yummy#good%20evening"

    out.remove_authority
    out.remove_query
    out.remove_fragment
    expect(out.encoded).to eq "test:/some/path/%3F/%23"
  end
end
