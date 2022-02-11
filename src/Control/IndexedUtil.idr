module Control.IndexedUtil

||| A version of const that works with a zero-quantity
||| ignored argument.
public export
const : b -> (0 _ : a) -> b
const x _ = x
