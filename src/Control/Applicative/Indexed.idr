module Control.Applicative.Indexed

import Control.Functor.Indexed

infixl 3 <<*>>

public export
interface IndexedFunctor z z m => IndexedApplicative z m | m where
  total
  pure : {0 i : z} -> (x : a) -> m a i i

  total
  ap : {0 i,j,k : z} -> m (a -> b) i j -> m a j k -> m b i k

public export
(<<*>>) : IndexedApplicative z m => m (a -> b) i j -> m a j k -> m b i k
(<<*>>) = ap

