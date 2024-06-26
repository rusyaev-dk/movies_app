abstract interface class KeyValueStorage {
  Future<void> init();

  Future<T?> get<T>({required String key});

  Future<void> set<T>({required String key, required T value});

  Future<void> delete<T>({required String key});
}
