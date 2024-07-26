test "Nat Enumeration" {
  fn natEnum() -> E[N] {
    pay(fn() { union(singleton(Z), fmap(N::S, natEnum())) })
  }

  inspect!(run(natEnum(), 2), content="[S(Z)]")
  inspect!(run(natEnum(), 11), content="[S(S(S(S(S(S(S(S(S(S(Z))))))))))]")
  inspect!(run(natEnum(), 12), content="[S(S(S(S(S(S(S(S(S(S(S(Z)))))))))))]")
}

fn boolEnum() -> E[Bool] {
  pay(fn() { union(singleton(true), singleton(false)) })
}

test "Bool Enumeration" {
  inspect!(run(boolEnum(), 0), content="[]")
  inspect!(run(boolEnum(), 1), content="[true, false]")
}

test "Bool List Enumeration" {
  fn bListEnum() -> E[@immut/list.T[Bool]] {
    pay(
      fn() {
        union(
          singleton(Nil),
          app(fmap(@tuple.curry(@immut/list.T::Cons), boolEnum()), bListEnum()),
        )
      },
    )
  }

  inspect!(run(bListEnum(), 2), content="[]")
  inspect!(run(bListEnum(), 3), content="[@list.of([true]), @list.of([false])]")
  inspect!(run(bListEnum(), 4), content="[]")
  inspect!(
    run(bListEnum(), 5),
    content="[@list.of([true, true]), @list.of([true, false]), @list.of([false, true]), @list.of([false, false])]",
  )
  inspect!(run(bListEnum(), 6), content="[]")
}

