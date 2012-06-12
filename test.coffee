assert = require 'assert'
{Card, Hand, PokerUtil} = require './index'

#test 'suite'
resSF = PokerUtil.evalHand Hand.makeHand ['3h', '4h', '5h', '6h', '7h', '8h', '9d']
assert.strictEqual resSF.score, 1, "score should be 1, but is #{resSF.score}"
assert.strictEqual resSF.rank, 'straight flush', "rank should be 'straight flush' but is '#{resSF.rank}'"

res4K = PokerUtil.evalHand Hand.makeHand ['5d', '5h', '5s', '5c', '7s', 'Ad', '9h']
assert.strictEqual res4K.score, 2, "score should be 2, but is #{res4K.score}"
assert.strictEqual res4K.rank, '4 of a kind', "rank should be '4 of a kind', but is '#{res4K.rank}'"

resFH = PokerUtil.evalHand Hand.makeHand ['Th', 'Td', '5h', 'Tc', '2s', '5d', '6h']
assert.strictEqual resFH.score, 3, "score should be 3, but is #{resFH.score}"
assert.strictEqual resFH.rank, 'full house', "rank should be 'full house', but is '#{resFH.rank}'"

resFL = PokerUtil.evalHand Hand.makeHand ['Th', '2h', '5h', 'Ah', '2s', '5d', '6h']
assert.strictEqual resFL.score, 4, "score should be 4, but is #{resFL.score}"
assert.strictEqual resFL.rank, 'flush', "rank should be 'flush', but is '#{resFL.rank}'"

resST = PokerUtil.evalHand Hand.makeHand ['2h', '3h', '5c', 'As', '2s', '4d', '6h']
assert.strictEqual resST.score, 5, "score should be 4, but is #{resST.score}"
assert.strictEqual resST.rank, 'straight', "rank should be 'straight', but is '#{resST.rank}'"

res3K = PokerUtil.evalHand Hand.makeHand ['5d', '5h', '5s', 'Qc', '7s', 'Ad', '9h']
assert.strictEqual res3K.score, 6, "score should be 6, but is #{res3K.score}"
assert.strictEqual res3K.rank, '3 of a kind', "rank should be '3 of a kind', but is '#{res3K.rank}'"

res2p = PokerUtil.evalHand Hand.makeHand ['5d', '5h', 'Ks', 'Qc', '7s', 'Kd', '9h']
assert.strictEqual res2p.score, 7, "score should be 6, but is #{res2p.score}"
assert.strictEqual res2p.rank, '2 pair', "rank should be '2 pair', but is '#{res2p.rank}'"

res1p = PokerUtil.evalHand Hand.makeHand ['4d', '7d', 'Kh', '2h', '7s', '8h', 'Ad']
assert.strictEqual res1p.score, 8, "score should be 8, but is #{res1p.score}"
assert.strictEqual res1p.rank, '1 pair', "rank should be '1 pair', but is '#{res1p.rank}'"

resHC = PokerUtil.evalHand Hand.makeHand ['4d', 'Kh', 'As', '2h', '7d', '8h', 'Jd']
assert.strictEqual resHC.score, 9, "score should be 9, but is #{resHC.score}"
assert.strictEqual resHC.rank, 'high card', "rank should be 'high card', but is '#{resHC.rank}'"
#end tests


###
#~deal rule returns the following:
( 
  ( </HA> </HQ> ) 
  ( </C10> </H4> )  
  ( </CA> </CJ> ) 
),  
  ( ( </D10> </DA> </C5> </D4> </D2> ) ) 
)

( 
  ( </C9> </DK> ) 
  ( </S5> </CK> )   
  ( </HK> </C2> ) 
), 
  ( ( </DJ> </D6> </CA> </S10> </H7> ) ) 
) 

( 
  ( </H3> </SK> ) 
  ( </D8> </SA> ) 
  ( </D2> </H9> ) 
),
  ( ( </HJ> </C5> </C2> </C9> </S7> ) ) 
) 
###



hands = 
  'avatars:elocin': ['Ah', 'Qh']
  'avatars:arti': ['Tc', '4h']
  'avatars:neoteric': ['Ac', 'Jc']

board = ['Th', 'Kh', '9h', '4d', 'Jh']

results = PokerUtil.evalGame hands, board

console.log results
