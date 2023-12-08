module Year2023
  class Day07
    def part1(input)
      hand_bids = input.strip.split("\n").map do |line|
        hand, bid = line.split(" ")
        bid = bid.to_i
        [hand, bid]
      end

      hand_bids = hand_bids.sort_by do |hand_bid|
        hand, _bid = hand_bid
        type(hand)
      end
      puts hand_bids.map(&:first).map{type(_1)}.inspect

      winnings = hand_bids.map.with_index do |hand_bid, index|
        _hand, bid = hand_bid
        bid * (index + 1)
      end

      winnings.sum
    end

    def type(hand, with_jokers=nil, strengths=nil)
      with_jokers = hand if with_jokers.nil?
      counts = hand.split("").group_by{ _1 }.transform_values(&:length)
      high = counts.max_by { _2 }.first
      low = counts.min_by { _2 }.first
      strengths = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse if strengths.nil?
      strength = with_jokers.split("").map{ strengths.index(_1) }
      
      if counts.values.max == 5
        [7, :five_of_a_kind, strength]
      elsif counts.values.max == 4
        [6, :four_of_a_kind, strength]
      elsif counts.values.sort == [2,3]
        [5, :full_house, strength]
      elsif counts.values.max == 3
        [4, :three_of_a_kind, strength]
      elsif counts.values.sort == [1,2,2]
        [3, :two_pair, strength]
      elsif counts.values.max == 2
        [2, :pair, strength]
      else
        [1, :high_card, strength]
      end
    end

    def part2(input)
      hand_bids = input.strip.split("\n").map do |line|
        hand, bid = line.split(" ")
        bid = bid.to_i
        [hand, bid]
      end

      hand_bids = hand_bids.sort_by do |hand_bid|
        hand, _bid = hand_bid

        chars = hand.split("")

        jokers = (0...(chars.length)).select do |i|
          hand[i] == "J"
        end

        options = %w[A K Q T 9 8 7 6 5 4 3 2].repeated_permutation(jokers.length)

        best = options.max_by do |option|
          new_hand = hand.dup

          jokers.zip(option).each do |pair|
            i, card = pair
            new_hand[i] = card
          end

          type(new_hand)
        end

        best_hand = hand.dup

        jokers.zip(best).each do |pair|
          i, card = pair
          best_hand[i] = card
        end

        type(best_hand, hand, %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse)
      end
      puts hand_bids.map(&:first).map{type(_1)}.zip(hand_bids.map(&:first)).inspect

      winnings = hand_bids.map.with_index do |hand_bid, index|
        _hand, bid = hand_bid
        bid * (index + 1)
      end

      winnings.sum
    end
  end
end
