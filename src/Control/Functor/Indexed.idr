module Control.Functor.Indexed

infixl 1 <<&>>
infixr 4 <<$>>, <<$, $>>

||| An Indexed Functor.
||| This interface is indexed backwards of similar utlities in Haskell
||| to make it more readily compatible with the evolution of a type from
||| Indexed simply on values (or types) but also on functions that depend on
||| those values.
|||
||| An indexed functor where the mappable type comes last does not later
||| refactor into what this library calls a TransitionIndexed type as readily.
public export
interface IndexedFunctor x y (0 f : Type -> x -> y -> Type) | f where
  total
  map : {0 j : x} -> {0 k : y} -> (a -> b) -> f a j k -> f b j k 

||| Map for indexed functors.
public export
(<<$>>) : IndexedFunctor x y f => (a -> b) -> f a j k -> f b j k
(<<$>>) = map

||| Flipped version of `<<$>>`
public export
(<<&>>) : IndexedFunctor x y f => f a j k -> (a -> b) -> f b j k
(<<&>>) = flip (<<$>>)

||| Run something for effects, replacing the return value afterwards.
public export
(<<$) : IndexedFunctor x y f => b -> f a j k -> f b j k
(<<$) = map . const

||| Flipped version of `<<$`
public export
($>>) : IndexedFunctor x y f => f a j k -> b -> f b j k
($>>) = flip (<<$)

||| Run something for effects, throwing away the return value.
%inline
public export
ignore : IndexedFunctor x y f => f a j k -> f () j k
ignore = map (const ())

