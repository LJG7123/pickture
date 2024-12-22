// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../dm_contact_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dmContactServiceHash() => r'a563a6803793ec90784388af0a5b2f52705e5cb8';

/// See also [dmContactService].
@ProviderFor(dmContactService)
final dmContactServiceProvider = AutoDisposeProvider<DMContactService>.internal(
  dmContactService,
  name: r'dmContactServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dmContactServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DmContactServiceRef = AutoDisposeProviderRef<DMContactService>;
String _$dmContactSearchHash() => r'7468275984b450b97e162e2feed2a3c79298a66c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [dmContactSearch].
@ProviderFor(dmContactSearch)
const dmContactSearchProvider = DmContactSearchFamily();

/// See also [dmContactSearch].
class DmContactSearchFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [dmContactSearch].
  const DmContactSearchFamily();

  /// See also [dmContactSearch].
  DmContactSearchProvider call(
    String query,
  ) {
    return DmContactSearchProvider(
      query,
    );
  }

  @override
  DmContactSearchProvider getProviderOverride(
    covariant DmContactSearchProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dmContactSearchProvider';
}

/// See also [dmContactSearch].
class DmContactSearchProvider
    extends AutoDisposeFutureProvider<List<UserModel>> {
  /// See also [dmContactSearch].
  DmContactSearchProvider(
    String query,
  ) : this._internal(
          (ref) => dmContactSearch(
            ref as DmContactSearchRef,
            query,
          ),
          from: dmContactSearchProvider,
          name: r'dmContactSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dmContactSearchHash,
          dependencies: DmContactSearchFamily._dependencies,
          allTransitiveDependencies:
              DmContactSearchFamily._allTransitiveDependencies,
          query: query,
        );

  DmContactSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(DmContactSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DmContactSearchProvider._internal(
        (ref) => create(ref as DmContactSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _DmContactSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DmContactSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DmContactSearchRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _DmContactSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with DmContactSearchRef {
  _DmContactSearchProviderElement(super.provider);

  @override
  String get query => (origin as DmContactSearchProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
