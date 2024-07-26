trait Enumerable {
  enumerate() -> Enumerate[Self]
}

impl Enumerable for N with enumerate() {
  en_pay(
    fn() { en_union(en_singleton(Z), en_fmap(N::S, Enumerable::enumerate())) },
  )
}

impl Enumerable for Bool with enumerate() {
  en_pay(fn() { en_union(en_singleton(true), en_singleton(false)) })
}

impl[E : Enumerable] Enumerable for @immut/list.T[E] with enumerate() {
  en_pay(
    fn() {
      en_union(
        en_singleton(Nil),
        en_app(
          en_fmap(@tuple.curry(@immut/list.Cons), E::enumerate()),
          Enumerable::enumerate(),
        ),
      )
    },
  )
}

impl[E : Enumerable] Enumerable for Forest[E] with enumerate() {
  en_pay(
    fn() { en_fmap(fn { forest => { forest, } }, Enumerable::enumerate()) },
  )
}

impl[E : Enumerable] Enumerable for Tree[E] with enumerate() {
  en_pay(
    fn() {
      en_union(
        en_fmap(Tree::Leaf, E::enumerate()),
        en_fmap(Tree::Branch, Enumerable::enumerate()),
      )
    },
  )
}
