abstract class DataBaseInterface {

  Future<void> init();

  Future<T?> get<T>(String key);

  Future<void> set<T>(String key, T value);

  Future<void> delete<T>(String key);

}
