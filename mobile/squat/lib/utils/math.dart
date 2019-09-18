import "dart:math";

double tanh(num x) {
  final a = exp(x), b = exp(-x);
  return a.isInfinite ? 1 : b.isInfinite ? -1 : (a - b) / (a + b);
}