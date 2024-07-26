struct Enumerate[T] {
  parts : LazyList[Finite[T]]
}

pub fn en_run[T](self : Enumerate[T]) -> LazyList[Finite[T]] {
  self.parts
}

pub fn en_empty[T]() -> Enumerate[T] {
  { parts: Nil }
}

pub fn en_singleton[T](val : T) -> Enumerate[T] {
  { parts: Cons(fin_pure(val), fn() { Nil }) }
}

pub fn en_index[T](e : Enumerate[T], idx : Int) -> T {
  let fin = e.parts
  loop fin, idx {
    Nil, _ => abort("index out of bounds")
    Cons(f, rest), i =>
      if i < f.fCard {
        (f.fIndex)(i)
      } else {
        continue rest(), i - f.fCard
      }
  }
}

pub fn en_union[T](e1 : Enumerate[T], e2 : Enumerate[T]) -> Enumerate[T] {
  { parts: zip_plus(fin_union, e1.parts, e2.parts) }
}

pub fn en_fmap[T, U](f : (T) -> U, e : Enumerate[T]) -> Enumerate[U] {
  { parts: e.parts.map(fn { x => fin_fmap(f, x) }) }
}

pub fn en_pay[T](f : () -> Enumerate[T]) -> Enumerate[T] {
  { parts: Cons(fin_empty(), fn() { f().parts }) }
}

pub fn en_prod[T, U](e1 : Enumerate[T], e2 : Enumerate[U]) -> Enumerate[(T, U)] {
  { parts: prod_helper(e1.parts, reversals(e2.parts)) }
}

fn prod_helper[T, U](
  xs : LazyList[Finite[T]],
  rys : LazyList[LazyList[Finite[U]]]
) -> LazyList[Finite[(T, U)]] {
  rys.map(fn(y) { convolution(xs, y) })
}

pub fn en_app[T, U](f : Enumerate[(T) -> U], e : Enumerate[T]) -> Enumerate[U] {
  en_fmap(
    fn(g) {
      let (ff, x) = g
      ff(x)
    },
    en_prod(f, e),
  )
}



