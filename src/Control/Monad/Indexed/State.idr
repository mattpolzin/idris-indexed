module Control.Monad.Indexed.State

import Control.Functor.Indexed
import Control.Applicative.Indexed
import Control.Monad.Indexed
import Control.Monad.Indexed.Do

||| Support for wrapping an IndexedMonad in another stateful
||| Monad.
||| The order of the parameters may seem odd compared to other
||| StateT types, but the ordering is such that an IndexedMonad 
||| type can be elevated to a TransitionIndexedMonad type without 
||| much refactoring.
public export
record IndexedStateT stateType x y (m : Type -> x -> y -> Type) a (i : x) (j : y) where
  constructor ST
  runStateT' : stateType -> m (stateType, a) i j

public export
%inline
runStateT : stateType -> IndexedStateT stateType x y m a i j -> m (stateType, a) i j
runStateT s act = runStateT' act s

public export
%inline
evalStateT : IndexedFunctor x y m => stateType -> IndexedStateT stateType x y m a i j -> m a i j
evalStateT s = map snd . runStateT s

public export
%inline
execStateT : IndexedFunctor x y m => stateType -> IndexedStateT stateType x y m a i j -> m stateType i j
execStateT s = map fst . runStateT s

public export
%inline
mapStateT : ({0 i : x} -> {0 j : y} -> m (s, a) i j -> n (s, b) i j) -> IndexedStateT s x y m a i j -> IndexedStateT s x y n b i j
mapStateT f m = ST $ f . runStateT' m

public export
lift : IndexedFunctor x y m => m a i j -> IndexedStateT stateType x y m a i j
lift z = ST $ \st => map (st,) z

implementation IndexedFunctor x y f => IndexedFunctor x y (IndexedStateT stateType x y f) where
  map f' (ST runStateT') = ST $ \st => map (mapSnd f') $ runStateT' st

public export
IndexedMonad z m => IndexedApplicative z (IndexedStateT stateType z z m) where
  pure x = ST $ \st => pure (st, x)

  (ST ff) `ap` (ST fx) = ST $ \st =>
                          ff st >>>= \(st', f) =>
                            fx st' >>>= \(st'', x) =>
                              pure (st'', f x)

public export
IndexedMonad z m => IndexedMonad z (IndexedStateT stateType z z m) where
  bind (ST f) g = ST $ \st =>
               f st >>>= \(st', x) =>
                 runStateT st' (g x)

public export
get : IndexedApplicative z m => IndexedStateT stateType z z m stateType i i
get = ST $ \st => pure (st, st)

public export
put : IndexedApplicative z m => stateType -> IndexedStateT stateType z z m () i i
put st = ST $ \_ => pure (st, ())

public export
modify : IndexedMonad z m => (stateType -> stateType) -> IndexedStateT stateType z z m () i i
modify f = do
  x <- get
  put (f x)

