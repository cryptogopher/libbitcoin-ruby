describe Bitcoin::ECPrivate do
  let(:secret) { "8010b1bb119ad37d4b65a1022a314897b1b3614b345974332cb1b9582cf03536" }
  let(:wif_compressed) { "L1WepftUBemj6H4XQovkiW1ARVjxMqaw4oj2kmkYqdG1xTnBcHfC" }
  let(:wif_uncompressed) { "5JngqQmHagNTknnCshzVUysLMWAjT23FWs1TgNU5wyFH5SB3hrP" }

  it 'constructs compressed object from compressed wif' do
    expect(described_class.new(wif_compressed).compressed()).to be true
  end

  it 'constructs uncompressed object from uncompressed wif' do
    expect(described_class.new(wif_uncompressed).compressed()).to be false
  end

  # FIXME: uncomment after adding formats/impl modules with:
  # base16_literal/encode_base16
  #
  #it 'properly encodes compressed wif from secret' do
  #  expect(described_class.new(base16_literal(secret)).encoded()).to eq wif_compressed
  #end
  #
  #it 'properly encodes uncompressed wif from secret' do
  #  expect(
  #    described_class.new(base16_literal(secret), 0x8000, false).encoded()
  #  ).to eq wif_uncompressed
  #end
  #
  #it 'properly decodes secret from compressed wif' do
  #  secret = described_class.new(wif_compressed)
  #  expect(encode_base16(secret.secret())).to eq secret
  #  expect(secret.version()).to eq 0x8000
  #  expect(secret.compressed()).to be true
  #end
  #
  #it 'properly decodes secret from uncompressed wif' do
  #  secret = described_class.new(wif_uncompressed)
  #  expect(encode_base16(secret.secret())).to eq secret
  #  expect(secret.version()).to eq 0x8000
  #  expect(secret.compressed()).to be false
  #end
end
