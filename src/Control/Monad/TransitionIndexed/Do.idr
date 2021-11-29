||| Provide Do-Notation support for Transition Indexed Monad. 
||| Withouth this, the Indexed interfaces use operators that
||| do not collide with the non-Indexed interfaces.
module Control.Monad.TransitionIndexed.Do

import Control.Monad.TransitionIndexed

public export
(>>=) : TransitionIndexedMonad z m => m a x f -> ((res : a) -> m b (f res) g) -> m b x g
(>>=) = (>>>=)

public export
(>>) : TransitionIndexedMonad z m => m () x f -> Lazy (m b (f ()) g) -> m b x g
(>>) = (>>>)

