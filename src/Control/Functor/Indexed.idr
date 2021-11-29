module Control.Functor.Indexed

infixr 4 <<$>>

public export
interface IndexedFunctor x y (0 f : Type -> x -> y -> Type) | f where
  total
  map : {0 j : x} -> {0 k : y} -> (a -> b) -> f a j k -> f b j k 

public export
(<<$>>) : IndexedFunctor x y f => (a -> b) -> f a j k -> f b j k
(<<$>>) = map

||| Run something for effects, throwing away the return value.
%inline
public export
ignore : IndexedFunctor x y f => f a j k -> f () j k
ignore = map (const ())

