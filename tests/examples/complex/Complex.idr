module Complex

import Control.Monad.TransitionIndexed
import Control.Monad.TransitionIndexed.Do

data Substate = Sub1 | Sub2

data ComplexState = First Substate | Second | Third

data IsFirst : ComplexState -> Type where
  ItIsFirst : IsFirst (First _)

||| Result of moving from Second to Third state
data Trans2Result = OK | Error

data ComplexCmd : (ty : Type) ->
                  ComplexState ->
                  (ty -> ComplexState) ->
                  Type where
  Init       :              ComplexCmd () (First Sub1) (const (First Sub1))
  SubTrans   :              ComplexCmd () (First Sub1) (const (First Sub2))
  Trans1Easy : IsFirst s => ComplexCmd () s (const Second)
  Trans1Hard :              ComplexCmd () (First Sub2) (const Second)
  Trans2     :              ComplexCmd Trans2Result Second (\case OK => Third; Error => Second)
  Cheat      :              ComplexCmd () Second (const Third)

  Pure : (res : ty) -> ComplexCmd ty (state_fn res) state_fn
  Bind : ComplexCmd a state1 state2_fn ->
          ((res: a) -> ComplexCmd b (state2_fn res) state3_fn) ->
          ComplexCmd b state1 state3_fn

TransitionIndexedPointed ComplexState ComplexCmd where
  pure = Pure

TransitionIndexedMonad ComplexState ComplexCmd where
  bind = Bind

easyProg : ComplexCmd () (First Sub1) (const Third)
easyProg = do
  Init
  Trans1Easy
  OK <- Trans2
    | Error => Cheat
  Pure ()

hardProg : ComplexCmd () (First Sub1) (const Third)
hardProg = do
  Init
  SubTrans
  Trans1Hard
  res <- Trans2
  case res of
       OK => Pure ()
       Error => Cheat

