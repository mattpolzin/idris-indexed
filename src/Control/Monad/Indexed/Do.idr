||| Provide Do-Notation support for Indexed Monad. Withouth this, the Indexed interfaces use
||| operators that do not collide with the non-Indexed interfaces.
module Control.Monad.Indexed.Do

import Control.Monad.Indexed

public export
(>>=) : IndexedMonad z m => m a i j -> (a -> m b j k) -> m b i k
(>>=) = (>>>=)

public export
(>>) : IndexedMonad z m => m () i j -> Lazy (m b j k) -> m b i k
(>>) = (>>>)

