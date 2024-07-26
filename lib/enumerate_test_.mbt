test "Bool Tests" {
  let boolE : Enumerate[Bool] = Enumerable::enumerate()
  inspect!(en_index(boolE, 0), content="true")
  inspect!(en_index(boolE, 1), content="false")
}

test "Bool List" {
  let bListE : Enumerate[@immut/list.T[Bool]] = Enumerable::enumerate()

  inspect!(en_index(bListE, 0), content="@list.of([])")
  inspect!(en_index(bListE, 1), content="@list.of([true])")
  inspect!(en_index(bListE, 2), content="@list.of([false])")
  inspect!(en_index(bListE, 10), content="@list.of([true, false, false])")
  inspect!(
    en_index(bListE, 100),
    content="@list.of([false, true, true, false, true, false])",
  )
  inspect!(
    en_index(bListE, 500),
    content="@list.of([false, false, false, false, true, false, true, false])",
  )
  inspect!(
    en_index(bListE, 2000),
    content="@list.of([false, false, false, false, true, false, true, true, true, false])",
  )
  inspect!(
    en_index(bListE, 10000),
    content="@list.of([true, true, false, false, false, true, true, true, false, true, true, true, false])",
  )
  inspect!(
    en_index(bListE, 50000),
    content="@list.of([false, true, true, true, true, false, false, true, false, true, false, true, true, true, false])",
  )
  inspect!(
    en_index(bListE, 100000),
    content="@list.of([false, true, true, true, true, false, false, true, false, true, false, true, true, true, true, false])",
  )
  inspect!(
    en_index(bListE, 3000000),
    content="@list.of([true, false, false, true, false, false, false, true, true, true, false, false, true, false, false, true, true, true, true, true, false])",
  )
}

test "Tree" {
  let bTreeE : Enumerate[Tree[Bool]] = Enumerable::enumerate()
  inspect!(en_index(bTreeE, 100), content="Branch({forest: @list.of([Leaf(true), Leaf(false), Branch({forest: @list.of([])}), Leaf(false)])})")
  inspect!(en_index(bTreeE, 500), content="Branch({forest: @list.of([Leaf(false), Leaf(false), Leaf(true), Branch({forest: @list.of([])}), Leaf(false)])})")
  inspect!(en_index(bTreeE, 1000), content="Branch({forest: @list.of([Branch({forest: @list.of([Leaf(false)])}), Leaf(false), Branch({forest: @list.of([])}), Leaf(false)])})")
}

