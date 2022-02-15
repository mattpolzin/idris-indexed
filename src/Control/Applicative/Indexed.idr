module Control.Applicative.Indexed

import Control.Functor.Indexed

infixl 3 <<*>>, <<*, *>>

public export
interface IndexedFunctor z z f => IndexedApplicative z f | f where
  total
  pure : {0 i : z} -> (x : a) -> f a i i

  total
  ap : {0 i,j,k : z} -> f (a -> b) i j -> f a j k -> f b i k

public export
(<<*>>) : IndexedApplicative z f => f (a -> b) i j -> f a j k -> f b i k
(<<*>>) = ap

public export
(<<*) : IndexedApplicative z f => f a i j -> f b j k -> f a i k
x <<* y = map const x <<*>> y

public export
(*>>) : IndexedApplicative z f => f a i j -> f b j k -> f b i k
x *>> y = map (const id) x <<*>> y

||| Conditionally execute an applicative expression when the boolean is true.
public export
when : IndexedApplicative z f => Bool -> Lazy (f () i i) -> f () i i
when True y  = y
when False y = pure ()

||| Execute an applicative expression unless the boolean is true.
%inline
public export
unless : IndexedApplicative z f => Bool -> Lazy (f () i i) -> f () i i
unless = when . not

||| Map each element of a structure to a computation, evaluate those
||| computations and discard the results.
public export
traverse_ : (Foldable t, IndexedApplicative z f) => (a -> f b i i) -> t a -> f () i i
traverse_ f = foldr ((*>>) . f) (pure ())

||| Evaluate each computation in a structure and discard the results.
public export
sequence_ : (Foldable t, IndexedApplicative z f) => t (f a i i) -> f () i i
sequence_ = foldr (*>>) (pure ())

||| Like `traverse_` but with the arguments flipped.
public export
for_ : (Foldable t, IndexedApplicative z f) => t a -> (a -> f b i i) -> f () i i
for_ = flip traverse_

