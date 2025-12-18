/// Representa um resultado que pode ser Left (erro) ou Right (sucesso)
class Either<L, R> {
  final L? _left;
  final R? _right;

  const Either.left(L left)
      : _left = left,
        _right = null;

  const Either.right(R right)
      : _left = null,
        _right = right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left as L;
  R get right => _right as R;

  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    if (isLeft) {
      return leftFn(_left as L);
    } else {
      return rightFn(_right as R);
    }
  }
}
