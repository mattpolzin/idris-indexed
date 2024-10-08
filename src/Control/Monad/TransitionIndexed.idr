module Control.Monad.TransitionIndexed

export
infixl 1 >>>=, =<<<, >>>

%hide Prelude.pure

||| A TransitionIndexed pointed type defines purity but is not necessarily
||| Applicative.
public export
interface TransitionIndexedPointed z (0 m : (ty : Type) -> z -> (ty -> z) -> Type) | m where
  pure : {0 a : Type} -> {0 f : a -> z} -> (x : a) -> m a (f x) f

||| A TransitionIndexed monad is like an indexed monad but the third
||| index is determined by a function that takes the first index as input.
|||
||| One readily available example of a type that fits this interface is
||| a type representing stateful transitions and the values that fall
||| out of them.
|||
||| For example, take the final Door example from "Type-Driven Development with Idris."
|||
|||    data DoorCmd : (ty : Type) ->
|||                   DoorState ->
|||                   (ty -> DoorState) ->
|||                   Type
public export
interface TransitionIndexedMonad z (0 m : (ty : Type) -> z -> (ty -> z) -> Type) | m where
  bind : {0 x : z} -> {0 f : a -> z} -> {0 g : b -> z} -> m a x f -> ((res : a) -> m b (f res) g) -> m b x g

public export
(>>>=) : TransitionIndexedMonad z m => m a x f -> ((res : a) -> m b (f res) g) -> m b x g
(>>>=) = bind

||| Flipped version of `>>>=
public export
(=<<<) : TransitionIndexedMonad z m => {0 a : Type} -> {0 f : a -> z} -> ((res : a) -> m b (f res) g) -> m a x f -> m b x g
(=<<<) = flip (>>>=)

public export
(>>>) : TransitionIndexedMonad z m => m () x f -> Lazy (m b (f ()) g) -> m b x g
(>>>) y w = y >>>= \() => w

||| Conditionally execute an expression when the boolean is true.
export
when : TransitionIndexedPointed z m => Bool -> Lazy (m () (f ()) f) -> m () (f ()) f
when True w  = w
when False w = pure ()

||| Execute an expression unless the boolean is true.
export
unless : TransitionIndexedPointed z m => Bool -> Lazy (m () (f ()) f) -> m () (f ()) f
unless = when . not

||| Map each element of a structure to a computation, evaluate those
||| computations and discard the results.
public export
traverse_ : (Foldable t, TransitionIndexedPointed z m, TransitionIndexedMonad z m) => (a -> m b x (const x)) -> t a -> m () x (const x)
traverse_ f = foldr (\x,acc => (f x) >>>= (const acc)) (pure ())

||| Evaluate each computation in a structure and discard the results.
public export
sequence_ : (Foldable t, TransitionIndexedPointed z m, TransitionIndexedMonad z m) => t (m a x (const x)) -> m () x (const x)
sequence_ = foldr (\x, acc => x >>>= (const acc)) (pure ())

||| Like `traverse_` but with the arguments flipped.
public export
for_ : (Foldable t, TransitionIndexedPointed z m, TransitionIndexedMonad z m) => t a -> (a -> m b x (const x)) -> m () x (const x)
for_ = flip traverse_

