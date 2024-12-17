import 'package:get_it/get_it.dart';
import 'package:todo/core/cache_helper.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
}
