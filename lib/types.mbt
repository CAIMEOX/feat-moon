enum N {
  Z
  S(N)
} derive(Show)

enum Tree[T] {
  Leaf(T)
  Branch(Forest[T])
} derive(Show)

struct Forest[T] {
  forest : @immut/list.T[Tree[T]]
} derive(Show)