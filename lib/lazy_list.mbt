enum LazyList[T] {
  Nil
  Cons(T, () -> LazyList[T])
}

pub fn index[T](self : LazyList[T], i : Int) -> T {
  match (self, i) {
    (Cons(x, _), 0) => x
    (Nil, _) => abort("index out of bounds")
    (Cons(_, xs), i) => xs().index(i - 1)
  }
}

pub fn concat[T](self : LazyList[T], other : LazyList[T]) -> LazyList[T] {
  match self {
    Nil => other
    Cons(x, xs) => Cons(x, fn() { concat(xs(), other) })
  }
}

pub fn map[T, U](self : LazyList[T], f : (T) -> U) -> LazyList[U] {
  match self {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), fn() { map(xs(), f) })
  }
}

pub fn fold_left[T, U](self : LazyList[T], f : (U, T) -> U, ~init : U) -> U {
  match self {
    Nil => init
    Cons(x, xs) => fold_left(xs(), f, init=f(init, x))
  }
}