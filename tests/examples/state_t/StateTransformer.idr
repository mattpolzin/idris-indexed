
import Control.Indexed
import Control.Monad.Indexed.State

data State = One | Two | Three

data Transition : Type -> State -> State -> Type where
  Pure : (x : a) -> Transition a s s
  First : Transition () One Two
  Second : Transition () Two Three
  Third : Transition () Three One
  Bind : Transition a x y -> (a -> Transition b y z) -> Transition b x z

IndexedFunctor State State Transition where
  map f (Pure x)   = Pure (f x)
  map f First      = Bind First  (Pure . f)
  map f Second     = Bind Second (Pure . f)
  map f Third      = Bind Third  (Pure . f)
  map f (Bind x g) = Bind x (\x' => map f (g x'))

[n1] IndexedApplicative State Transition where
  pure = Pure
  ap (Pure f) x = map f x
  ap (Bind y f) x = 
    Bind y $ \y' =>
      Bind (f y') $ \f' =>
        Bind x (\x' => Pure (f' x'))

IndexedMonad State Transition using n1 where
  bind = Bind

data Meta = Description String

||| A Transition plus some metadata
TransitionPlus : Type -> State -> State -> Type
TransitionPlus = IndexedStateT Meta State State Transition

main : TransitionPlus () One One
main = do
  put $ Description "meta text"
  lift $ do
    First
    Second
  x <- get
  lift $ do
    Indexed.ignore $ Pure x
    Third

