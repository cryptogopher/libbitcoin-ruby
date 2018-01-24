require 'spec_helper'

describe Bitcoin do
  it 'parses limits' do
    expect(decode_base10("0")).to eq 0
    expect(decode_base10("18446744073709551615")).to eq Bitcoin::max_uint64
  end

  it 'parses max money' do
    expect(
      decode_base10("20999999.9769", Bitcoin::btc_decimal_places)
    ).to eq Bitcoin::max_money
    expect(
      decode_base10("20999999.97690001", Bitcoin::btc_decimal_places)
    ).to eq Bitcoin::max_money+1
  end
end
