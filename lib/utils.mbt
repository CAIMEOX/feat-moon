fn sum(a : Array[Int]) -> Int {
  a.fold_left(Int::op_add, init=0)
}

fn sum_list(l : LazyList[Int]) -> Int {
  l.fold_left(Int::op_add, init=0)
}

fn conv[A, B, C](
  f : (A, B) -> C,
  fx : (Int) -> A,
  fy : (Int) -> B,
  p : Int
) -> Array[C] {
  Array::makei(p, fn(k) { f(fx(k), fy(p - k)) })
}

fn zip_with[A, B, C](
  f : (A, B) -> C,
  xs : LazyList[A],
  ys : LazyList[B]
) -> LazyList[C] {
  match (xs, ys) {
    (Cons(x, xs), Cons(y, ys)) =>
      Cons(f(x, y), fn() { zip_with(f, xs(), ys()) })
    (_, _) => Nil
  }
}

fn convolution[A, B](
  xs : LazyList[Finite[A]],
  ys : LazyList[Finite[B]]
) -> Finite[(A, B)] {
  let s1 = xs.map(fn(x) { x.fCard })
  let s2 = ys.map(fn(x) { x.fCard })
  let card = sum_list(zip_with(Int::op_mul, s1, s2))
  let fx = zip_with(fin_cart, xs, ys).fold_left(fin_union, init=fin_empty()).fIndex
  { fCard: card, fIndex: fx }
}

// fn zip_plus[T](f : (T, T) -> T, a1 : Array[T], a2 : Array[T]) -> Array[T] {
//   let (l1, l2) = (a1.length(), a2.length())
//   let (arr, lo) = if l1 < l2 { (a2, l1) } else { (a1, l2) }
//   Array::makei(
//     arr.length(),
//     fn(i) { if i < lo { f(a1[i], a2[i]) } else { arr[i] } },
//   )
// }

fn zip_plus[T](
  f : (T, T) -> T,
  ls1 : LazyList[T],
  ls2 : LazyList[T]
) -> LazyList[T] {
  match (ls1, ls2) {
    (Cons(x, xs), Cons(y, ys)) =>
      Cons(f(x, y), fn() { zip_plus(f, xs(), ys()) })
    (xs, ys) => xs.concat(ys)
  }
}

fn reversals[T](l : LazyList[T]) -> LazyList[LazyList[T]] {
  fn go {
    _, Nil => Nil
    rev, Cons(x, xs) => {
      let rev1 = Cons(x, rev)
      Cons(rev1, fn() { go(fn() { rev1 }, xs()) })
    }
  }

  go(fn() { Nil }, l)
}

pub fn curry3[A, B, C, D](f : (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
  fn { a => fn { b => fn { c => f(a, b, c) } } }
}

pub fn curry4[A, B, C, D, E](
  f : (A, B, C, D) -> E
) -> (A) -> (B) -> (C) -> (D) -> E {
  fn { a => fn { b => fn { c => fn { d => f(a, b, c, d) } } } }
}
