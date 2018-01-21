require 'spec_helper'

describe Bitcoin do
  it 'has a version number' do
    expect(Bitcoin::VERSION).not_to be nil
  end
end

describe Bitcoin::BitcoinURI do
  # Constructors
  it 'does not construct uninitialized' do
    expect(described_class.new("").valid?).to be false
  end

  it 'constructs initialized' do
    expect(described_class.new("bitcoin:").valid?).to be true
  end

  it 'normalizes mixed case scheme' do
    expect(described_class.new("bitcOin:").encoded()).to eq "bitcoin:"
  end

  it 'does not construct invalid scheme' do
    expect(described_class.new("fedcoin:").valid?).to be false
  end

  it 'does not construct from payment address only' do
    expect(described_class.new("113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD").valid?).to be false
  end

  it 'does not construct from stealth address only' do
    expect(
      described_class.new("hfFGUXFPKkQ5M6LC6aEUKMsURdhw93bUdYdacEtBA8XttLv7evZkira2i").valid?
    ).to be false
  end

  it 'does not construct from fragment' do
    expect(described_class.new("bitcoin:#satoshi").valid?).to be false
  end

  it 'does not construct strict from non-strict data' do
    expect(described_class.new("bitcoin:?label=Some テスト").valid?).to be false
  end

  it 'constructs non-strict from non-strict data' do
    expect(described_class.new("bitcoin:?label=Some テスト", false).valid?).to be true
  end

  # Setters
  it 'properly encodes payment address set using set_path' do
    expected_payment = "113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD"
    expected_uri = "bitcoin:" + expected_payment
    
    uri = described_class.new
    expect(uri.set_path(expected_payment)).to be true
    expect(uri.encoded()).to eq expected_uri
  end

  it 'properly encodes stealth address set using set_path' do
    expected_payment = "hfFGUXFPKkQ5M6LC6aEUKMsURdhw93bUdYdacEtBA8XttLv7evZkira2i"
    expected_uri = "bitcoin:" + expected_payment
    
    uri = described_class.new
    expect(uri.set_path(expected_payment)).to be true
    expect(uri.encoded()).to eq expected_uri
  end

  it 'properly encodes stealth address reset after payment address' do
    expected_stealth = "hfFGUXFPKkQ5M6LC6aEUKMsURdhw93bUdYdacEtBA8XttLv7evZkira2i"
    expected_uri = "bitcoin:" + expected_stealth

    uri = described_class.new
    payment = Bitcoin::PaymentAddress.new("113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD")
    expect(payment.valid?).to be true
    uri.set_address(payment)
    uri.set_address(Bitcoin::StealthAddress.new(expected_stealth))
    expect(uri.encoded()).to eq expected_uri
  end

  it 'properly encodes payment address reset after stealth address' do
    expected_payment = "113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD"
    expected_uri = "bitcoin:" + expected_payment

    uri = described_class.new
    stealth = Bitcoin::StealthAddress
      .new("hfFGUXFPKkQ5M6LC6aEUKMsURdhw93bUdYdacEtBA8XttLv7evZkira2i")
    expect(stealth.valid?).to be true
    uri.set_address(stealth)
    uri.set_address(Bitcoin::PaymentAddress.new(expected_payment))
    expect(uri.encoded()).to eq expected_uri
  end

  it 'does not reset path with set_path' do
    expected_payment = "113Pfw4sFqN1T5kXUnKbqZHMJHN9oyjtgD"
    expected_uri = "bitcoin:" + expected_payment

    uri = described_class.new
    uri.set_address(Bitcoin::StealthAddress
      .new("hfFGUXFPKkQ5M6LC6aEUKMsURdhw93bUdYdacEtBA8XttLv7evZkira2i"))

    # The set_path will not reset a path.
    # This is necessary to catch failures in non-strict parsing.
    expect(uri.set_path(expected_payment)).to be false
  end

  it 'keeps latter amount when amount reset with set_amount' do
    uri = described_class.new
    uri.set_amount(10000000000);
    uri.set_amount(120000);
    expect(uri.encoded()).to eq "bitcoin:?amount=0.0012"
  end
end
