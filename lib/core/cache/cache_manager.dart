class CacheEntry<T> {
  final T value;
  final DateTime expiryTime;

  CacheEntry(this.value, Duration ttl) : expiryTime = DateTime.now().add(ttl);

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}

class CacheManager<T> {
  final Map<String, CacheEntry<T>> _cache = {};
  final Duration _defaultTTL;

  CacheManager({Duration? defaultTTL}) : _defaultTTL = defaultTTL ?? const Duration(minutes: 30);

  T? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.value;
  }

  void set(String key, T value, {Duration? ttl}) {
    _cache[key] = CacheEntry(value, ttl ?? _defaultTTL);
  }

  void setAll(Map<String, T> entries, {Duration? ttl}) {
    entries.forEach((key, value) {
      set(key, value, ttl: ttl);
    });
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  void removeExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }
}
