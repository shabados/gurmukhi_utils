# frozen_string_literal: true

require 'spec_helper'
require 'gurmukhi_utils'

RSpec.describe GurmukhiUtils do
  describe '.ascii' do
    context 'general cases' do
      let(:assertions) do
        {
          '੧੨੩' => '123',
          'ੴ ☬ ੴ' => '<> Ç <>',
          'ਗੁਰੂ' => 'gurU'
        }
      end

      it 'converts Gurmukhi Unicode to ASCII' do
        assertions.each do |key, value|
          expect(GurmukhiUtils.ascii(key)).to eq(value)
        end
      end
    end

    context 'yayya' do
      let(:assertions) do
        {
          # Yayya
          'ਯਕੀਂ' => 'XkIN',
          'ਪ੍ਰਿਯ' => 'ipRX',
          # ...
          'ਤ꠳ਯਾਗ꠳ਯੋ' => 'qÎwgÎo',
          'ਜ꠳ਯੋਂ' => 'jÎoN',
          # Open-top Yayya
          'ਨਾਮ꠴ਯ' => 'nwmï',
          # ...
          'ਸ꠴ਯਾਮ' => 'sïwm',
          # Open-top Half-Y
          'ਦਿਤ꠴ਯਾਦਿਤ꠵ਯ' => 'idqïwidqî',
          'ਤ੍ਰਸ꠵ਯੋ' => 'qRsîo'
        }
      end

      it 'converts Gurmukhi Unicode with yayya cases to ASCII' do
        assertions.each do |key, value|
          expect(GurmukhiUtils.ascii(key)).to eq(value)
        end
      end
    end
  end
end
