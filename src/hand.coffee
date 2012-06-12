Card = require "./card"

Hand = (cards) ->
  throw new Error("Hand must have at least 5") if cards.length < 5
  @nums = 0
  @suits = 0
  @numcards = 0
  @parseHand cards
  return @nums


Hand::parseHand = (cards) ->
  @numcards = cards.length
  cards = cards.sort(Hand.sortCards)
  suitsIndex = 0
  lastNum = 0
  i = 0

  while i < cards.length
    card = 1
    j = 0

    while j < cards[i].num
      card = card << 1
      j++

    @nums = @nums | card
    
    unless cards[i].num is lastNum
      suitsIndex++
      lastNum = cards[i].num
    
    suit = 1
    k = 0

    while k < cards[i].suit
      suit = suit << 1
      k++
    
    suit = suit << (suitsIndex * 4)
    @suits = @suits | suit
    i++
  
  @cards = cards


Hand.sortCards = (a, b) ->
  a.num < b.num


# hand - array of 5-7 cards
Hand.makeHand = (hand) ->
  cards = []
  i = 0

  while i < hand.length
    cards.push Card.makeCard(hand[i])
    i++
  new Hand(cards)

module.exports = Hand