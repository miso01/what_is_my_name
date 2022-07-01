import 'dart:core';
import 'dart:math' as math;
import 'dart:math';


toThreeDecimals(double number) {
  int decimals = 3;
  int fac = pow(10, decimals);
  return (number * fac).round() / fac;
}


Iterable<T> zip<T>(Iterable<T> a, Iterable<T> b) sync* {
  final itA = a.iterator;
  final itB = b.iterator;
  bool hasA, hasB;
  while ((hasA = itA.moveNext()) | (hasB = itB.moveNext())) {
    if (hasA) yield itA.current;
    if (hasB) yield itB.current;
  }
}

int generate6DigitsNumber() {
  var random = new math.Random();
  var next = random.nextDouble() * 1000000;
  while (next < 100000) {
    next *= 10;
  }
  return next.toInt();
}

