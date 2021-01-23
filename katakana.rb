#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

system('clear')

MONOGRAPHS = { 'ア': 'a', 'イ': 'i', 'ウ': 'u', 'エ': 'e', 'オ': 'o',
               'カ': 'ka', 'キ': 'ki', 'ク': 'ku', 'ケ': 'ke', 'コ': 'ko',
               'サ': 'sa', 'シ': 'shi', 'ス': 'su', 'セ': 'se', 'ソ': 'so',
               'タ': 'ta', 'チ': 'chi', 'ツ': 'tsu', 'テ': 'te', 'ト': 'to',
               'ナ': 'na', 'ニ': 'ni', 'ヌ': 'nu', 'ネ': 'ne', 'ノ': 'no',
               'ハ': 'ha', 'ヒ': 'hi', 'フ': 'fu', 'ヘ': 'he', 'ホ': 'ho',
               'マ': 'ma', 'ミ': 'mi', 'ム': 'mu', 'メ': 'me', 'モ': 'mo',
               'ヤ': 'ya', 'ユ': 'yu', 'ヨ': 'yo',
               'ラ': 'ra', 'リ': 'ri', 'ル': 'ru', 'レ': 're', 'ロ': 'ro',
               'ワ': 'wa', 'ヲ': 'wo',
               'ン': 'n' }.freeze

DIACRITICS = { 'ガ': 'ga', 'ギ': 'gi', 'グ': 'gu', 'ゲ': 'ge', 'ゴ': 'go',
               'ザ': 'za', 'ジ': 'ji', 'ズ': 'zu', 'ゼ': 'ze', 'ゾ': 'zo',
               'ダ': 'da', 'ヂ': 'ji', 'ヅ': 'zu', 'デ': 'de', 'ド': 'do',
               'バ': 'ba', 'ビ': 'bi', 'ブ': 'bu', 'ベ': 'be', 'ボ': 'bo',
               'パ': 'pa', 'ピ': 'pi', 'プ': 'pu', 'ペ': 'pe', 'ポ': 'po' }.freeze

# Are you ready?
class Practice
  def initialize(selection, quick: nil)
    @selection = selection.to_a.shuffle!
    @selection = @selection[0...(rand(@selection.length))] if quick
    @count = @selection.count
    @score = 0
    puts "Practice set for #{@count} katakana is ready!"
  end

  def write_char
    katakana, english = next!
    print "In katakana write: #{english}"
    gets.chomp
    puts "Answer: #{katakana}"
    puts
  end

  def guess_char
    katakana, english = next!
    print "In english write: #{katakana}"
    @score += 1 if english == gets.chomp
    puts "Answer: #{english}"
    puts
  end

  private

  def next!
    if @selection.empty?
      puts 'Practice set complete!'
      puts "#{(@score.to_f / @count).round(1) * 100}% correct!" unless @score.zero?
      exit
    end

    @selection.pop
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: h.rb [options]'

  opts.on('-s', '--simple', 'No (han)daukten.') do |_v|
    options[:simple] = true
  end

  opts.on('-w', '--write', 'Write down the corresponding katakana.') do |_v|
    options[:write] = 'write_char'
  end

  opts.on('-g', '--guess', 'Guess the corresponding pronounciation.') do |_v|
    options[:guess] = 'guess_char'
  end

  opts.on('-r', '--random', 'Randomly guess or write each char.') do |_v|
    options[:random] = true
  end

  opts.on('-q', '--quick', 'Practice on subset of full alphabet.') do |_v|
    options[:quick] = true
  end
end.parse!

selection = MONOGRAPHS.dup
selection.merge! DIACRITICS unless options.delete('simple')

practice_set = Practice.new(selection, quick: options.delete(:quick))

mode = (options.delete(:write) || options.delete(:guess))
if mode
  loop do
    practice_set.send :"#{mode}"
  end
else
  loop do
    rand > 0.5 ? practice_set.write_char : practice_set.guess_char
  end
end
