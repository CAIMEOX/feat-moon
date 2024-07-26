struct E[M] {
  rep : (Int) -> Finite[M]
}

pub fn run[M](self : E[M], i : Int) -> Array[M] {
  (self.rep)(i).to_array().1
}

pub fn pack[M](val : (Int) -> Finite[M]) -> E[M] {
  { rep: val }
}

pub fn empty[M]() -> E[M] {
  pack(fn { _ => fin_empty() })
}

pub fn singleton[M](x : M) -> E[M] {
  pack(
    fn {
      0 => fin_pure(x)
      _ => fin_empty()
    },
  )
}

pub fn fmap[M, N](f : (M) -> N, e : E[M]) -> E[N] {
  { rep: fn { p => fin_fmap(f, (e.rep)(p)) } }
}

pub fn union[M](e1 : E[M], e2 : E[M]) -> E[M] {
  pack(fn { p => fin_union((e1.rep)(p), (e2.rep)(p)) })
}

pub fn prod[M, N](e1 : E[M], e2 : E[N]) -> E[(M, N)] {
  pack(fn(p) { fin_concat(conv(fin_cart, e1.rep, e2.rep, p)) })
}

pub fn app[M, N](f : E[(M) -> N], a : E[M]) -> E[N] {
  fmap(
    fn(g) {
      let (ff, x) = g
      ff(x)
    },
    prod(f, a),
  )
}

pub fn pay[M](e : () -> E[M]) -> E[M] {
  pack(
    fn {
      0 => fin_empty()
      n => (e().rep)(n - 1)
    },
  )
}