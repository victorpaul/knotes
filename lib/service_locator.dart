import 'package:get_it/get_it.dart';
import 'services/storage_service.dart';

final getIt = GetIt.instance;

/// Setup all services for dependency injection
Future<void> setupServiceLocator() async {
  // Register StorageService as a singleton
  getIt.registerLazySingleton<StorageService>(() => StorageService());

  // Initialize StorageService
  await getIt<StorageService>().init();
}
