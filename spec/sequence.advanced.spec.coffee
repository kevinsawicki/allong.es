{sequence, sequence: {Identity, Maybe, Writer, List, Then, Callback}} = require('../lib/allong.es.js').allong.es

describe "Sequence", ->
  
  describe "Naive", ->

    double = (n) -> n + n
    plusOne = (n) -> n + 1
  
    it "should be a thing", ->
      expect( sequence ).not.toBeNull()
    
    it "should return a function when given a function", ->
      expect( sequence(double) ).not.toBeNull()
  
    it "should do a single function", ->
      expect( sequence(double)(3) ).toEqual 6
  
    it "should do two functions", ->
      expect( sequence(double, plusOne)(3) ).toEqual 7
    
  describe "Identity", ->

    double = (n) -> n + n
    plusOne = (n) -> n + 1
    
    it "should be a thing", ->
      expect( Identity ).not.toBeNull()    
  
    it "should do a single function", ->
      expect( sequence(Identity, double)(3) ).toEqual 6
  
    it "should do two functions", ->
      expect( sequence(Identity, double, plusOne)(3) ).toEqual 7
    
  describe "Maybe", ->

    double = (n) -> n + n
    plusOne = (n) -> n + 1
  
    it "should pass numbers through", ->
      expect( sequence(Maybe, double, plusOne)(3) ).toEqual 7
  
    it "should pass null through", ->
      expect( sequence(Maybe, double, plusOne)(null) ).toBeNull()
  
    it "should pass undefined through", ->
      expect( sequence(Maybe, double, plusOne)(undefined) ).toBeUndefined()
    
    it "should short-circuit", ->
      expect( sequence(Maybe, double, ((x) ->), plusOne)(undefined) ).toBeUndefined()
      
  describe "Writer", ->
  
    parity = (n) ->
      [
        n
        if n % 2 is 0 then 'even' else 'odd'
      ]
    
    space = (n) ->
      [
        n
        ' '
      ]
    
    size = (n) ->
      [
        n
        if n < 10 then 'small' else 'normal'
      ]
  
    it "should accumulate writes", ->
      expect( sequence(Writer, parity, space, size)(5) ).toEqual [5, 'odd small']
    
  describe 'List', ->
  
    oneToN = (n) ->
      [1..n]
  
    nToOne = (n) ->
      [n..1]
    
    it "should handle two levels of lists", ->
      expect( sequence(List, oneToN, nToOne)(3) ).toEqual [1, 2, 1, 3, 2, 1]