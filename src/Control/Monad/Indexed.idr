module Control.Monad.Indexed

import Control.Functor.Indexed
import Control.Applicative.Indexed

infixl 1 >>>=, =<<<, >>>, >>=>, <=<<

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

||| Flipped version of `>>>=`
public export
(=<<<) : IndexedMonad z m => (a -> m b j k) -> m a i j -> m b i k
(=<<<) = flip (>>>=)

||| Sequence effects taking the value of the second.
public export
(>>>) : IndexedMonad z m => m () i j -> Lazy (m b j k) -> m b i k
(>>>) x y = x >>>= \_ => y

||| Left-to-right Kleisli composition of indexed monads.
public export
(>>=>) : IndexedMonad z m => (a -> m b i j) -> (b -> m c j k) -> (a -> m c i k)
(>>=>) f g x = f x >>>= g

||| Right-to-left Kleisli composition of indexed monads, flipped version of `>=>`.
public export
(<=<<) : IndexedMonad z m => (b -> m c j k) -> (a -> m b i j) -> (a -> m c i k)
(<=<<) = flip (>>=>)
