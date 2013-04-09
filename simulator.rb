require 'minitest/autorun'

module Generators
	class Multiplicative
		attr_accessor :seed, :modulo, :x
		
		def initialize(params = {})
			@seed = params[:seed]
			@modulo = params[:modulo]
			@x = params[:x0]
		end
		
		def next
			# generates a new number
			number = @seed * @x % @modulo
			puts "Number generated = #{@number} | seed = #{@seed} | modulo = #{@modulo} | x = #{@x}"
			@x = number
			return number
		end
	end
end


class Game
	attr_accessor :budget, :bet, :last_won, :last_bet
	 
	def initialize(generator, budget, bet)
		@generator = generator
		@budget = budget
		@bet = bet
		@last_won = nil
		@last_bet = 0
	end
	
	def play
		rounds = 1
		puts "Rounds=#{rounds} Budget=#{budget}"
		until (rounds == 40 || budget <= 0)
			if (rounds == 1 || last_won)
				@bet = bet if bet <= budget
				@bet = budget if bet > budget
			elsif last_won == false
				@bet = last_bet * 2 if last_bet * 2 <= budget
				@bet = budget if last_bet * 2 > budget 
			end
			
			puts "**************************************************************"
			puts "Rounds = #{rounds} | Budget = #{budget} | Bet = #{bet} | Last_Won? = #{last_won}"
			
			if @generator.next > 500
				@last_won = true
				@budget += bet
				puts "YOU WON!"
			else
				@last_won = false
				@budget -= bet
				puts "YOU LOST!"
			end

			puts "New values => Rounds = #{rounds} | Budget = #{budget} | Bet = #{bet} | Last_Won? = #{last_won}"
			puts "**************************************************************\n\n"
			
			rounds += 1
			@last_bet = bet
		end
			
		puts "xxx GAME OVER xxx" 
	end
end


describe Generators::Multiplicative do
	it 'should be able to set the values for seed, x0, and modulo' do
		generator = Generators::Multiplicative.new seed:203, modulo:1000, x0:9
		
		generator.seed.must_equal 203
		generator.x.must_equal 9
		generator.modulo.must_equal 1000
	end
end


describe Game do
	it 'new instance require budget values' do
		generator = Generators::Multiplicative.new seed:203, modulo:1000, x0:9
		game = Game.new(generator, 1000, 10)
		
		game.wont_be_nil
	end
	
	it 'budget and bet values should not be nil' do
		generator = Generators::Multiplicative.new seed:203, modulo:1000, x0:9
		game = Game.new(generator, 1000, 10)
		
		game.budget.must_equal 1000
		game.bet.must_equal 10
	end
	
  it 'whit the values seed:203, modulo:1000, x0:9, it must lost in the round 14' do
		generator = Generators::Multiplicative.new seed:203, modulo:1000, x0:9
		game = Game.new(generator, 1000, 10)
		game.play()
		
		game.budget.must_equal 0
		game.bet.must_equal 200
	end
end


### Data to run the program
generator = Generators::Multiplicative.new seed:203, modulo:1000, x0:9
game = Game.new(generator, 1000, 10)
game.play()