module Door

-- Adapted from:
-- https://github.com/idris-lang/Idris2/blob/523c0a6d7823d2b9a614d4a30efb52da015f9367/tests/typedd-book/chapter14/DoorJam.idr

import Control.Monad.TransitionIndexed
import Control.Monad.TransitionIndexed.Do

data DoorState = DoorClosed | DoorOpen

data DoorResult = OK | Jammed

data DoorCmd : (0 ty : Type) ->
               DoorState ->
               (0 _ : ty -> DoorState) ->
               Type where
  Open :     DoorCmd DoorResult DoorClosed (\res => case res of
                                                         OK => DoorOpen
                                                         Jammed => DoorClosed)
  Close :    DoorCmd ()         DoorOpen   (const DoorClosed)
  RingBell : DoorCmd ()         DoorClosed (const DoorClosed)

  Display : String -> DoorCmd () state (const state)

  Pure : (res : ty) -> DoorCmd ty (state_fn res) state_fn
  Bind : DoorCmd a state1 state2_fn ->
          ((res: a) -> DoorCmd b (state2_fn res) state3_fn) ->
          DoorCmd b state1 state3_fn

TransitionIndexedMonad DoorState DoorCmd where
  bind = Bind

logOpen : DoorCmd DoorResult DoorClosed
                             (\res => case res of
                                           OK => DoorOpen
                                           Jammed => DoorClosed)
logOpen = do Display "Trying to open the door"
             OK <- Open | Jammed => do Display "Jammed"
                                       Pure Jammed
             Display "Success"
             Pure OK

doorProg : DoorCmd () DoorClosed (const DoorClosed)
doorProg = do RingBell
              jam <- Open
              Display "Trying to open the door"
              case jam of
                   OK => do Display "Glad To Be Of Service"
                            Close
                   Jammed => Display "Door Jammed"

doorProg2 : DoorCmd () DoorClosed (const DoorClosed)
doorProg2 = do RingBell
               OK <- Open | Jammed => Display "Door Jammed"
               Display "Glad To Be Of Service"
               Close
               OK <- Open | Jammed => Display "Door Jammed"
               Display "Glad To Be Of Service"
               Close

