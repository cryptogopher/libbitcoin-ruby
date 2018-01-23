# -*- coding: ascii-8bit -*-
describe Bitcoin::URIReader do
  it 'parses typical uri' do
    uri = described_class.parse("bitcoin:113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD?amount=0.1")
    expect(uri.valid?).to be true
    expect(uri.payment.encoded).to eq "113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD"
    expect(uri.amount).to eq 10_000_000
    expect(uri.label.empty?).to be true
    expect(uri.message.empty?).to be true
    expect(uri.r.empty?).to be true
  end

  it 'parses valid scheme' do
    expect(described_class.parse("bitcoin:").valid?).to be true
    expect(described_class.parse("Bitcoin:").valid?).to be true
    expect(described_class.parse("bitcOin:").valid?).to be true
    expect(described_class.parse("BITCOIN:").valid?).to be true
  end

  it 'does not parse invalid scheme' do
    expect(described_class.parse("bitcorn:").valid?).to be false
  end
  
  it 'parses empty name parameter' do
    expect(described_class.parse("bitcoin:?").valid?).to be true
    expect(described_class.parse("bitcoin:?&").valid?).to be true
    expect(described_class.parse("bitcoin:?=y").valid?).to be true
    expect(described_class.parse("bitcoin:?=").valid?).to be true
  end

  it 'parses valid unknown optional parameters' do
    expect(described_class.parse("bitcoin:?x=y").valid?).to be true
    expect(described_class.parse("bitcoin:?x=").valid?).to be true
    expect(described_class.parse("bitcoin:?x").valid?).to be true

    uri = described_class.parse("bitcoin:?ignore=true")
    expect(uri.valid?).to be true
    expect(uri.address.empty?).to be true
    expect(uri.amount).to eq 0
    expect(uri.label.empty?).to be true
    expect(uri.message.empty?).to be true
    expect(uri.r.empty?).to be true
    expect(uri.parameter("ignore").empty?).to be true
  end

  it 'does not parse invalid unknown optional parameter' do
    expect(described_class.parse("bitcoin:?req-ignore=false").valid?).to be false
  end

  it 'parses valid address' do
    uri = described_class.parse("bitcoin:113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD")
    expect(uri.valid?).to be true
    expect(uri.payment.encoded()).to eq "113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD"
    expect(uri.amount).to eq 0
    expect(uri.label.empty?).to be true
    expect(uri.message.empty?).to be true
    expect(uri.r.empty?).to be true
  end

  it 'parses uri encoded address' do
    uri = described_class.parse("bitcoin:%3113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD")
    expect(uri.valid?).to be true
    expect(uri.payment.encoded()).to eq "113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD"
  end

  it 'does not parse invalid address' do
    expect(described_class.parse("bitcoin:&").valid?).to be false
    expect(described_class.parse("bitcoin:19l88").valid?).to be false
    expect(described_class.parse("bitcoin:19z88").valid?).to be false
  end

  it 'parses amount only' do
    uri = described_class.parse("bitcoin:?amount=4.2")
    expect(uri.valid?).to be true
    expect(uri.payment.valid?).to be false
    expect(uri.amount).to eq 420_000_000
    expect(uri.label.empty?).to be true
    expect(uri.message.empty?).to be true
    expect(uri.r.empty?).to be true
  end

  it 'parses minimal amount' do
    uri = described_class.parse("bitcoin:?amount=.")
    expect(uri.valid?).to be true
    expect(uri.amount).to eq 0
  end

  it 'does not parse invalid amount' do
    expect(described_class.parse("bitcoin:amount=4.2.1").valid?).to be false
    expect(described_class.parse("bitcoin:amount=bob").valid?).to be false
  end

  it 'parses label only' do
    uri = described_class.parse("bitcoin:?label=test")
    expect(uri.valid?).to be true
    expect(uri.payment.valid?).to be false
    expect(uri.amount).to eq 0
    expect(uri.label).to eq "test"
    expect(uri.message.empty?).to be true
    expect(uri.r.empty?).to be true
  end

  it 'parses reserved symbol with lowercase percent' do
    uri = described_class.parse("bitcoin:?label=%26%3d%6b")
    expect(uri.label).to eq "&=k"
  end

  it 'does not parse invalid percent encoding' do
    expect(described_class.parse("bitcoin:label=%3").valid?).to be false
    expect(described_class.parse("bitcoin:label=%3G").valid?).to be false
  end

  it 'parses encoded multibyte utf8' do
    uri = described_class.parse("bitcoin:?label=%E3%83%95")
    expect(uri.label).to eq "フ"
  end

  it 'parses non-strict encoded multibyte utf8 with unencoded label space' do
    uri = described_class.parse("bitcoin:?label=Some テスト", false)
    expect(uri.label).to eq "Some テスト"
  end

  it 'does not parse strict encoded multibyte utf8 with unencoded label space' do
    expect(described_class.parse("bitcoin:?label=Some テスト", true).valid?).to be false
  end

  it 'parses message only' do
    uri = described_class.parse("bitcoin:?message=Hi%20Alice")
    expect(uri.valid?).to be true
    expect(uri.payment.valid?).to be false
    expect(uri.amount).to eq 0
    expect(uri.label.empty?).to be true
    expect(uri.message).to eq "Hi Alice"
    expect(uri.r.empty?).to be true
  end

  it 'parses payment protocol only' do
    uri = described_class.parse("bitcoin:?r=http://www.example.com?purchase%3Dshoes")
    expect(uri.valid?).to be true
    expect(uri.payment.valid?).to be false
    expect(uri.amount).to eq 0
    expect(uri.label.empty?).to be true
    expect(uri.message.empty?).to be true
    expect(uri.r).to eq "http://www.example.com?purchase=shoes"
  end

  # TODO: custom_reader not implemented
end
