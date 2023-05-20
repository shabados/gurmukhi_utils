# frozen_string_literal: true

module GurmukhiUtils
  # Translators available
  TRANSLATORS = ['guru_latn', 'guru_latn_pa'].freeze

  require_relative 'converters/guru_latn'

  # Converts text from a script to another.
  #
  # Some script converters are lossless and others are lossy. Transliteration attempts
  # to be compliant with reversible mappings (i.e. to a target script and then back
  # to unicode gurmukhi with zero data loss). Transcription attempts to be representative
  # of the spoken word (biased by today's languages). Script converters are named with
  # two script tags (based on ISO 15924) for transliteration, and an additional language
  # tag (based on ISO 639-1) for transcription. Additional information may be added at
  # the end to indicate school of thought or other methodology info.
  #
  # @param string [String] The string to affect.
  # @param script_converter [String] The method of converting one script to another. Defaults to "guru_latn_pa".
  #
  # @return [String] A string where a script is converted to another script.
  def self.convert(string, script_converter = 'guru_latn')
    raise 'Invalid translator' unless TRANSLATORS.include?(script_converter)

    # Convert Unicode to Sant Lipi format
    string.gsub!('੍ਯ', '꠳ਯ')

    # Normalize Unicode
    # string = unicode_normalize(string) # Implement normalization method if needed

    case script_converter
    when 'guru_latn'
      string = GurmukhiUtils.guru_latn(string)
    when 'guru_latn_pa'
      string = GurmukhiUtils.guru_latn_pa(string)
    end

    return string
  end
end
