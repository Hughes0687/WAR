require_relative 'sq.rb'

class Card

  attr_reader :rank, :value, :suit

  def initialize(rank, value, suit)
    @rank = rank
    @value = value
    @suit = suit
  end

end

class Deck

  attr_reader :deck

  def initialize
    @deck = SQ::Queue.new
    @temp_deck = []
  end

  def create_52_card_deck
    created_deck = []
    suits = ["H", "D", "S", "C"]
    rank =  %w(2 3 4 5 6 7 8 9 10 J Q K A)
    value = %w(1 2 3 4 5 6 7 8 9 10 11 12 13 14)

    suits.each do |x|
      value.each_index do |y|
        created_deck << Card.new(rank[y],value[y],x)
      end
    end

    @temp_deck = created_deck

  end

  def add_card(card)
    @deck.push(card)
  end

  def deal_card
    @deck.shift
  end

  def shuffle
    shuffled = []
    size = n = @temp_deck.length

    while shuffled.length < size
      i = rand(n)
      @temp_deck[i], @temp_deck[-1] = @temp_deck[-1], @temp_deck[i]
      shuffled << @temp_deck.pop
      n -= 1
    end
    @deck = SQ::Queue.new
    shuffled.each do |x|
      @deck.push(x)
    end
  end

end

class Player

  attr_accessor :name, :hand

  def initialize(name)
    @name = name
    @hand = Deck.new
  end

end


class War

  def initialize(player1, player2)
    @deck = Deck.new
    @deck.create_52_card_deck
    @deck.shuffle
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)

    while (@deck.deck.peek != nil)
        card1 = @deck.deal_card
        @player1.hand.add_card(card1)
        card2 = @deck.deal_card
        @player2.hand.add_card(card2)
    end

  end



  def play
    turns = 0
    while ((card1=@player1.hand.deal_card) != nil && (card2=@player2.hand.deal_card) != nil)
      answer = WarAPI.play_turn(@player1, card1, @player2, card2)

      if answer[@player2].empty?
        @player1.hand.add_card(answer[@player1][1])
        @player1.hand.add_card(answer[@player1][0]) 
      else
        @player2.hand.add_card(answer[@player2][1]) 
        @player2.hand.add_card(answer[@player2][0])
      end

      turns += 1
      print card1.value.to_s + " " + card2.value.to_s
    end
    return turns
  end

end


class WarAPI

  def self.play_turn(player1, card1, player2, card2)
    if card1.value > card2.value
      {player1 => [card1, card2], player2 => []}
    elsif card2.value > card1.value
      {player1 => [], player2 => [card2, card1]}
    else
      {player1 => [card1], player2 => [card2]}
    end
  end

end


games = []
100.times {games<< War.new("Stevo", "Loser").play}
puts "average: #{average = games.inject(:+)/100}"