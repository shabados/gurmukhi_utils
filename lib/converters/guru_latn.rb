# frozen_string_literal: true

module GurmukhiUtils
  ROMAN_REPLACEMENTS = {
    'ਕ਼' => 'q',
    '੍ਯ' => 'y̶', # half-yayya uses strikethrough U+0336
    '꠳ਯ' => 'y̶',
    '꠴ਯ' => 'ƴ', # open-top yayya uses latin y with hook U+01B4
    '꠵ਯ' => 'ƴ̶', # open-top half-yayya is a combination of U+01B4 and U+0336
    'ੵ' => 'ʸ',
    '੍ਹ' => 'ʰ',
    '੍ਰ' => 'ʳ',
    '੍ਵ' => 'ᵛ',
    '੍ਟ' => 'ᵗ̣',
    '੍ਤ' => 'ᵗ',
    '੍ਨ' => 'ⁿ',
    '੍ਚ' => 'ᶜ'
  }.freeze

  ROMAN_TRANSLATIONS = {
    'ਾ'.ord => 'ā',
    'ੇ'.ord => 'e',
    'ੈ'.ord => 'ē',
    'ਿ'.ord => 'i',
    'ੀ'.ord => 'ī',
    'ੋ'.ord => 'o',
    'ੌ'.ord => 'ō',
    'ੁ'.ord => 'u',
    'ੂ'.ord => 'ū',
    'ਅ'.ord => 'a',
    "\u0a06".ord => 'ā',  # ਆ
    "\u0a0f".ord => 'e',  # ਏ
    "\u0a10".ord => 'ē',  # ਐ
    "\u0a07".ord => 'i',  # ਇ
    "\u0a08".ord => 'ī',  # ਈ
    "\u0a13".ord => 'o',  # ਓ
    "\u0a14".ord => 'ō',  # ਔ
    "\u0a09".ord => 'u',  # ਉ
    "\u0a0a".ord => 'ū',  # ਊ
    'ਸ'.ord => 's',
    'ਹ'.ord => 'h',
    'ਕ'.ord => 'k',
    'ਖ'.ord => 'kh',
    'ਗ'.ord => 'g',
    'ਘ'.ord => 'gh',
    'ਙ'.ord => 'ṅ',
    'ਚ'.ord => 'c',
    'ਛ'.ord => 'ch',
    'ਜ'.ord => 'j',
    'ਝ'.ord => 'jh',
    'ਞ'.ord => 'ñ',
    'ਟ'.ord => 'ṭ',
    'ਠ'.ord => 'ṭh',
    'ਡ'.ord => 'ḍ',
    'ਢ'.ord => 'ḍh',
    'ਣ'.ord => 'ṇ',
    'ਤ'.ord => 't',
    'ਥ'.ord => 'th',
    'ਦ'.ord => 'd',
    'ਧ'.ord => 'dh',
    'ਨ'.ord => 'n',
    'ਪ'.ord => 'p',
    'ਫ'.ord => 'ph',
    'ਬ'.ord => 'b',
    'ਭ'.ord => 'bh',
    'ਮ'.ord => 'm',
    'ਯ'.ord => 'y',
    'ਰ'.ord => 'r',
    'ਲ'.ord => 'l',
    'ਵ'.ord => 'v',
    'ੜ'.ord => 'ṛ',
    'ਸ਼'.ord => 'sh',
    'ਖ਼'.ord => 'x',
    'ਗ਼'.ord => 'ġ',
    'ਜ਼'.ord => 'z',
    'ਫ਼'.ord => 'f',
    'ਲ਼'.ord => 'ḷ',
    '਼'.ord => '°',
    '੦'.ord => '0',
    '੧'.ord => '1',
    '੨'.ord => '2',
    '੩'.ord => '3',
    '੪'.ord => '4',
    '੫'.ord => '5',
    '੬'.ord => '6',
    '੭'.ord => '7',
    '੮'.ord => '8',
    '੯'.ord => '9',
    'ੑ'.ord => '̧', # U+0327 Combining Cedilla
    'ੱ'.ord => '˘',
    'ੰ'.ord => '⸛',
    'ਂ'.ord => '⸞',
    'ਃ'.ord => 'ẖ',
    '।'.ord => '|',
    '॥'.ord => '‖' # U+2016 Double Vertical Line
  }.freeze

  def self.guru_latn(string)
    # Confirm normalized Gurmukhi
    # string = unicode_normalize(string) # Implement normalization method if needed

    # Ik Oankar
    string.gsub!('ੴ', 'ਇਕ ਓਅੰਕਾਰ')

    # Add inherent vowel / Mukta (ਮੁਕਤਾ = ਅ)
    # Between words
    non_vowel_modifiers = '਼ੑੵ਼'
    pre_base_ligature = '꠳꠴꠵'
    post_letters = 'ਆਏਐਇਈਓਔਉਊ'
    pre_post_modifiers = 'ੱਂੰ'

    regex_pattern = /([#{GurmukhiUtils::BASE_LETTERS}][#{non_vowel_modifiers}]?)(?=[#{pre_base_ligature}#{GurmukhiUtils::BASE_LETTERS}#{post_letters}#{pre_post_modifiers}])/
    string.gsub!(regex_pattern, '\1ਅ')

    # Single letter
    single_char_pattern = /(^|\s|$)([#{GurmukhiUtils::BASE_LETTERS}][#{non_vowel_modifiers}]?)([#{GurmukhiUtils::VIRAMA}][#{GurmukhiUtils::BELOW_LETTERS}]|#{GurmukhiUtils::YAKASH})?(^|\s|$)/
    string.gsub!(single_char_pattern, '\1\2\3ਅ\4')

    ROMAN_REPLACEMENTS.each do |key, value|
      string.gsub!(key, value)
    end

    # The [key] is an integer representation of a Unicode character's code point
    # and the pack('U') function converts this code point back to a Unicode character.
    # gsub! then substitutes every occurrence of this character in the string
    # with its corresponding romanized representation from the ROMAN_TRANSLATIONS hash.
    #
    # For example, if key = 2607 ("ਗ" in Unicode), [key].pack('U') will convert it back to "ਗ".
    # The gsub! function will then replace all occurrences of "ਗ" in the string with "g"
    # (as defined in ROMAN_TRANSLATIONS).
    ROMAN_TRANSLATIONS.each do |key, value|
      #   string.gsub!([key].pack('U'), value)
      string.gsub!(key, value)
    end

    return string
  end
end
