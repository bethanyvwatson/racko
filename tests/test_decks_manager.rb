require "test/unit"

require_relative "../lib/decks_manager.rb"

class TestDecksManager < Test::Unit::TestCase

  def setup
    @manager = DecksManager.new
  end

  # draw pile should be a racko deck
  # discard should be a deck
  def test_initialize
    assert_kind_of(RackoDeck, @manager.draw_pile)

    assert_kind_of(Deck, @manager.discard_pile)
  end

  # should take top card from draw pile, place on top of discard pile
  def test_discard_top_card
    top_card = @manager.draw_pile.cards[0]
    assert_not_equal(top_card, @manager.discard_pile.cards[0])
    @manager.discard_top_card
    assert_equal(top_card, @manager.discard_pile.cards[0])
  end

  # should move all cards from discard pile into draw pile
  def test_reshuffle_discard_into_draw
    # drain the draw pile into the discard pile
    while !@manager.draw_pile.is_empty?
      @manager.discard_top_card
    end
    assert_equal([], @manager.draw_pile.cards)
    assert_not_equal([], @manager.discard_pile.cards)

    @manager.reshuffle_discard_into_draw

    # draw pile should have cards and discard pile should be empty again
    assert_equal([], @manager.discard_pile.cards)
    assert_not_equal([], @manager.draw_pile.cards)
  end
end