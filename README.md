
# Indexed
A little foundation around indexed interfaces for functor, applicative, and monad.

The idea is to support types like those used for the "Door" example common in Edwin's talks and the TDD book.

Some incarnations of these indexed types can be represented as
```idris
data Door : Type -> DoorState -> DoorState -> Type
```
which lends itself to the traditional definition of indexed functor, applicatve, and monad (or at least the definition found in some Haskell libraries). This package surfaces `IndexedFunctor`, `IndexedApplicative`, and `IndexedMonad` that suit this well.

More complication versions of these indexed types will represent the second state as a function of the result type
```idris
data Door : (a : Type) -> DoorState -> (a -> DoorState) -> Type
```
which is no longer a functor or applicative (as far as I have been able to figure, without representing the second state transition function as a data type itself). This package surfaces `TransitionIndexedPointed` and `TransitionIndexedMonad` that suit this use-case. The `Pointed` interface declares a `pure` function and the `Monad` interface declares a `bind` function.

I've also started to add other useful things in around the base monad extensions like an `IndexedStateT` type.

### Disambiguating do-notation
Not all do-statements cause trouble, but longer do-statements sometimes need to be disambiguated.

If you need to disambiguate a do-statement that uses an indexed monad implementation, you can use:
```idris
Indexed.do
  ...
```
in contrast to, say, a traditional monad:
```idris
Prelude.do
  ...
```
