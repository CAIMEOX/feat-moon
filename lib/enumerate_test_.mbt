fn boolE() -> Enumerate[Bool] {
  en_pay(fn() { en_union(en_singleton(true), en_singleton(false)) })
}

test "Bool Tests" {
  inspect!(en_index(boolE(), 0), content="true")
  inspect!(en_index(boolE(), 1), content="false")
}

test "Bool List" {
  fn bListE() -> Enumerate[@immut/list.T[Bool]] {
    en_pay(
      fn() {
        en_union(
          en_singleton(Nil),
          en_app(en_fmap(@tuple.curry(@immut/list.Cons), boolE()), bListE()),
        )
      },
    )
  }

  inspect!(en_index(bListE(), 0), content="@list.of([])")
  inspect!(en_index(bListE(), 1), content="@list.of([true])")
  inspect!(en_index(bListE(), 2), content="@list.of([false])")
  inspect!(en_index(bListE(), 10), content="@list.of([true, false, false])")
  inspect!(
    en_index(bListE(), 100),
    content="@list.of([false, true, true, false, true, false])",
  )
  inspect!(
    en_index(bListE(), 500),
    content="@list.of([false, false, false, false, true, false, true, false])",
  )
  inspect!(
    en_index(bListE(), 2000),
    content="@list.of([false, false, false, false, true, false, true, true, true, false])",
  )
  inspect!(
    en_index(bListE(), 10000),
    content="@list.of([true, true, false, false, false, true, true, true, false, true, true, true, false])",
  )
  inspect!(
    en_index(bListE(), 50000),
    content="@list.of([false, true, true, true, true, false, false, true, false, true, false, true, true, true, false])",
  )
  inspect!(
    en_index(bListE(), 100000),
    content="@list.of([false, true, true, true, true, false, false, true, false, true, false, true, true, true, true, false])",
  )
  inspect!(
    en_index(bListE(), 3000000),
    content="@list.of([true, false, false, true, false, false, false, true, true, true, false, false, true, false, false, true, true, true, true, true, false])",
  )
}
