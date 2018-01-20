require 'spec_helper'

describe Bitcoin do
  it 'has a version number' do
    expect(Bitcoin::VERSION).not_to be nil
  end
end

describe Bitcoin::BitcoinURI do
  it 'doesn\'t construct uninitialized' do
    expect(described_class.new("").valid?).to be false
  end

  it 'constructs initialized' do
    expect(described_class.new("bitcoin:").valid?).to be true
  end

  it 'normalizes mixed case scheme' do
    expect(described_class.new("bitcOin:").encoded()).to eq "bitcoin:"
  end

  it 'doesn\'t construct invalid scheme' do
    expect(described_class.new("fedcoin:").valid?).to be false
  end

  it 'doesn\'t construct from payment address only' do
    expect(described_class.new("113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD").valid?).to be false
  end
end
