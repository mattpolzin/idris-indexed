module Control.Monad.TransitionIndexed

infixl 1 >>>=, >>>

public export
interface TransitionIndexedMonad z (0 m : (0 ty : Type) -> z -> (0 _ : ty -> z) -> Type) | m where
  bind : {0 x : z} -> {0 f : a -> z} -> {0 g : b -> z} -> m a x f -> ((res : a) -> m b (f res) g) -> m b x g

public export
(>>>=) : TransitionIndexedMonad z m => m a x f -> ((res : a) -> m b (f res) g) -> m b x g
(>>>=) = bind

public export
(>>>) : TransitionIndexedMonad z m => m () x f -> Lazy (m b (f ()) g) -> m b x g
(>>>) y w = y >>>= \() => w

