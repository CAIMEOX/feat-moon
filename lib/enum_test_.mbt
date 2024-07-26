enum N {
  Z
  S(N)
} derive(Show)

enum Tree[T] {
  Leaf
  Branch(Tree[T], T, Tree[T])
} derive(Show)

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

test "Bool Tree Enumeration" {
  fn bTreeEnum() -> E[Tree[Bool]] {
    pay(
      fn() {
        union(
          singleton(Leaf),
          app(
            app(fmap(curry3(Tree::Branch), bTreeEnum()), boolEnum()),
            bTreeEnum(),
          ),
        )
      },
    )
  }

  inspect!(run(bTreeEnum(), 1), content="[Leaf]")
  inspect!(run(bTreeEnum(), 2), content="[]")
  inspect!(run(bTreeEnum(), 3), content="[]")
  inspect!(
    run(bTreeEnum(), 4),
    content="[Branch(Leaf, true, Leaf), Branch(Leaf, false, Leaf)]",
  )
  inspect!(
    run(bTreeEnum(), 7),
    content="[Branch(Leaf, true, Branch(Leaf, true, Leaf)), Branch(Leaf, true, Branch(Leaf, false, Leaf)), Branch(Leaf, false, Branch(Leaf, true, Leaf)), Branch(Leaf, false, Branch(Leaf, false, Leaf)), Branch(Branch(Leaf, true, Leaf), true, Leaf), Branch(Branch(Leaf, true, Leaf), false, Leaf), Branch(Branch(Leaf, false, Leaf), true, Leaf), Branch(Branch(Leaf, false, Leaf), false, Leaf)]",
  )
}
