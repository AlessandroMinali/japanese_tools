#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

system('clear')

MONOGRAPHS = { 'あ': 'a', 'い': 'i', 'う': 'u', 'え': 'e', 'お': 'o',
               'か': 'ka', 'き': 'ki', 'く': 'ku', 'け': 'ke', 'こ': 'ko',
               'さ': 'sa', 'し': 'shi', 'す': 'su', 'せ': 'se', 'そ': 'so',
               'た': 'ta', 'ち': 'chi', 'つ': 'tsu', 'て': 'te', 'と': 'to',
               'な': 'na', 'に': 'ni', 'ぬ': 'nu', 'ね': 'ne', 'の': 'no',
               'は': 'ha', 'ひ': 'hi', 'ふ': 'fu', 'へ': 'he', 'ほ': 'ho',
               'ま': 'ma', 'み': 'mi', 'む': 'mu', 'め': 'me', 'も': 'mo',
               'や': 'ya', 'ゆ': 'yu', 'よ': 'yo',
               'ら': 'ra', 'り': 'ri', 'る': 'ru', 'れ': 're', 'ろ': 'ro',
               'わ': 'wa', 'を': 'o',
               'ん': 'n' }.freeze

DIACRITICS = { 'が': 'ga', 'ぎ': 'gi', 'ぐ': 'gu', 'げ': 'ge', 'ご': 'go',
               'ざ': 'za', 'じ': 'ji', 'ず': 'zu', 'ぜ': 'ze', 'ぞ': 'zo',
               'だ': 'da', 'ぢ': 'ji', 'づ': 'zu', 'で': 'de', 'ど': 'do',
               'ば': 'ba', 'び': 'bi', 'ぶ': 'bu', 'べ': 'be', 'ぼ': 'bo',
               'ぱ': 'pa', 'ぴ': 'pi', 'ぷ': 'pu', 'ぺ': 'pe', 'ぽ': 'po' }.freeze

# Are you ready?
class Practice
  def initialize(selection, quick: nil)
    @selection = selection.to_a.shuffle!
    @selection = @selection[0...(rand(@selection.length))] if quick
    @count = @selection.count
    @score = 0
    puts "Practice set for #{@count} hiragana is ready!"
  end

  def write_char
    hiragana, english = next!
    print "In hiragana write: #{english}"
    gets.chomp
    puts "Answer: #{hiragana}"
    puts
  end

  def guess_char
    hiragana, english = next!
    print "In english write: #{hiragana}"
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

  opts.on('-w', '--write', 'Write down the corresponding hiragana.') do |_v|
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
