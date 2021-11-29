module Control.Monad.Indexed

import Control.Functor.Indexed
import Control.Applicative.Indexed

infixl 1 >>>=, >>>

public export
interface IndexedApplicative z m => IndexedMonad z m | m where
  total
  bind : {0 i,j,k : z} -> m a i j -> (a -> m b j k) -> m b i k

  total
  join : {0 i,j,k : z} -> m (m a j k) i j -> m a i k

  -- default implementations
  bind x f = join (map f x)
  join x = bind x id

public export
(>>>=) : IndexedMonad z m => m a i j -> (a -> m b j k) -> m b i k
(>>>=) = bind

public export
(>>>) : IndexedMonad z m => m () i j -> Lazy (m b j k) -> m b i k
(>>>) x y = x >>>= \_ => y

