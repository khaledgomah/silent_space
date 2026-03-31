import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/usecases/usecase.dart';

void registerMocktailFallbacks() {
  // NoParams is commonly used in use case calls and avoids repetitive
  // fallback registration in each test file that relies on mocktail any().
  registerFallbackValue(_NoParamsFake());
}

class _NoParamsFake extends NoParams {
  _NoParamsFake();
}
