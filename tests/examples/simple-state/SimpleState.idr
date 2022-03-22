
import Control.Indexed

data State = One | Two | Three

data Transition : Type -> State -> State -> Type where
  Pure : (x : a) -> Transition a s1 s2
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

IndexedApplicative State Transition where
  pure = Pure
  ap (Pure f) x = Bind (Pure ()) (\_ => f <<$>> x)
  ap (Bind y f) x = 
    Bind y $ \y' =>
      Bind (f y') $ \f' =>
        Bind x (\x' => Pure (f' x'))

IndexedMonad State Transition where
  bind = Bind

main : Transition () One One
main = 
  do First
     Second
     Indexed.ignore $ Pure "hello"
     Third

