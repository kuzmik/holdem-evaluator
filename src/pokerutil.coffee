Masks = require("./mask")
Hand = require("./hand")


PokerUtil =
  suitMasks:
    SPADE: parseInt("0001000100010001000100010001", 2)
    HEART: parseInt("0010001000100010001000100010", 2)
    CLUB: parseInt("0100010001000100010001000100", 2)
    DIAMOND: parseInt("1000100010001000100010001000", 2)

  numBits4:
    "0000": 0
    "0001": 1
    "0010": 1
    "0011": 2
    "0100": 1
    "0101": 2
    "0110": 2
    "0111": 3
    "1000": 1
    "1001": 2
    "1010": 2
    "1011": 3
    "1100": 2
    "1101": 3
    "1110": 3
    "1111": 4

  numBits5:
    "00000": 0
    "00001": 1
    "00010": 1
    "00011": 2
    "00100": 1
    "00101": 2
    "00110": 2
    "00111": 3
    "01000": 1
    "01001": 2
    "01010": 2
    "01011": 3
    "01100": 2
    "01101": 3
    "01110": 3
    "01111": 4
    "10000": 1
    "10001": 2
    "10010": 2
    "10011": 3
    "10100": 2
    "10101": 3
    "10110": 3
    "10111": 4
    "11000": 2
    "11001": 3
    "11010": 3
    "11011": 4
    "11100": 3
    "11101": 4
    "11110": 4
    "11111": 5

  suitBits: [ 1, 2, 4, 8 ]

  cardBits: [ 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096 ]


  padSuit: (suit) ->
    ("000000000000000000000000000000000000" + suit.toString(2)).slice -28


  padNum: (num) ->
    ("0000000000000" + num.toString(2)).slice -13


  padSingleSuit: (suit) ->
    ("0000" + suit.toString(2)).slice -4


  countNums: (nums) ->
    nums = PokerUtil.padNum(nums)
    a = nums.substr(0, 5)
    b = nums.substr(5, 5)
    c = "00" + nums.substr(10, 3)
    PokerUtil.numBits5[a] + PokerUtil.numBits5[b] + PokerUtil.numBits5[c]


  countSuits: (suits) ->
    spades = PokerUtil.suitMasks.SPADE & suits
    hearts = PokerUtil.suitMasks.HEART & suits
    clubs = PokerUtil.suitMasks.CLUB & suits
    diamonds = PokerUtil.suitMasks.DIAMOND & suits
    spades: PokerUtil.countSuit(spades)
    hearts: PokerUtil.countSuit(hearts)
    clubs: PokerUtil.countSuit(clubs)
    diamonds: PokerUtil.countSuit(diamonds)


  countSuit: (suit) ->
    suit = PokerUtil.padSuit(suit)
    a = suit.substr(0, 5)
    b = suit.substr(5, 5)
    c = suit.substr(10, 5)
    d = suit.substr(15, 5)
    e = suit.substr(20, 5)
    f = "00" + suit.substr(25, 3)
    PokerUtil.numBits5[a] + PokerUtil.numBits5[b] + PokerUtil.numBits5[c] + PokerUtil.numBits5[d] + PokerUtil.numBits5[e] + PokerUtil.numBits5[f]


  testStraight: (nums) ->
    i = Masks.straights.length - 1

    while i >= 0
      return true  if (Masks.straights[i] & nums) is Masks.straights[i]
      i--
    false


  test4k: (suits) ->
    i = 0

    while i < 7
      mask = 15 << (i * 4)
      return true if (mask & suits) == mask
      i++


  test3k: (suits) ->
    i = 0

    while i < 7
      curSuit = ((15 << (i * 4)) & suits) >> (i * 4)
      return true if PokerUtil.numBits4[PokerUtil.padSingleSuit(curSuit.toString(2))] > 2
      i++
    false


  test2p: (suits) ->
    pairsFound = 0
    i = 0

    while i < 7
      curSuit = ((15 << (i * 4)) & suits) >> (i * 4)
      pairsFound++ if PokerUtil.numBits4[PokerUtil.padSingleSuit(curSuit.toString(2))] > 1
      return 2 if pairsFound >= 2
      i++
    pairsFound


  evalGame: (hands, board) ->
    results = { }
    for k of hands
      h = hands[k].concat board
      hand = Hand.makeHand(h)
      results[k] = @evalHand(hand)

      console.log "avatar: #{k} // cards: #{h} // rank: #{rank}" if @debug
      console.log hand if @debug
    return results


  evalHand: (hand) ->
    sf = false
    k4 = false
    fh = false
    fl = false
    st = false
    k3 = false
    p2 = false
    p1 = false
    hc = true

    #evaluate suits in hand
    suitCount = PokerUtil.countSuits(hand.suits)

    #eval card numbers/ranks in hand
    numCount = PokerUtil.countNums(hand.nums)
    
    #flush
    fl = true if suitCount.spades > 4 or suitCount.hearts > 4 or suitCount.clubs > 4 or suitCount.diamonds > 4
    
    #four of a kind
    k4 = PokerUtil.test4k(hand.suits)
    
    #straight
    st = PokerUtil.testStraight(hand.nums)
    
    #straight flush if straight AND flush
    sf = true if st and fl
    
    #3 of a kind
    k3 = PokerUtil.test3k(hand.suits)
    
    #full house: 3 of a kind and 1 pair
    fh = k3 and numCount <= (hand.numcards - 3)
    
    #count the number of paids found
    pairsFound = PokerUtil.test2p(hand.suits)
    
    #2 pair
    p2 = pairsFound is 2

    #1 pair
    p1 = pairsFound > 0


    result = { }
    if sf
      result.rank = "straight flush"
      result.score = 1
    else if k4
      result.rank =  "4 of a kind"
      result.score = 2
    else if fh
      result.rank = "full house"
      result.score = 3
    else if fl
      result.rank =  "flush"
      result.score = 4
    else if st
      result.rank =  "straight"
      result.score = 5
    else if k3
      result.rank =  "3 of a kind"
      result.score = 6
    else if p2
      result.rank =  "2 pair"
      result.score = 7
    else if p1
      result.rank =  "1 pair"
      result.score = 8
    else
      result.rank =  "high card"
      result.score = 9

    return result


module.exports = PokerUtil