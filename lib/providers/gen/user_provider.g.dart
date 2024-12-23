// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userServiceHash() => r'd202c375439ba7e228837169af5a32c16c9ddb4a';

/// See also [userService].
@ProviderFor(userService)
final userServiceProvider = AutoDisposeProvider<UserService>.internal(
  userService,
  name: r'userServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserServiceRef = AutoDisposeProviderRef<UserService>;
String _$userHash() => r'd6c3c772f88407c60c5aa0d1f4bfccd83a015b9e';

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

/// See also [user].
@ProviderFor(user)
const userProvider = UserFamily();

/// See also [user].
class UserFamily extends Family<AsyncValue<UserModel?>> {
  /// See also [user].
  const UserFamily();

  /// See also [user].
  UserProvider call(
    String userId,
  ) {
    return UserProvider(
      userId,
    );
  }

  @override
  UserProvider getProviderOverride(
    covariant UserProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userProvider';
}

/// See also [user].
class UserProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// See also [user].
  UserProvider(
    String userId,
  ) : this._internal(
          (ref) => user(
            ref as UserRef,
            userId,
          ),
          from: userProvider,
          name: r'userProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
          dependencies: UserFamily._dependencies,
          allTransitiveDependencies: UserFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<UserModel?> Function(UserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProvider._internal(
        (ref) => create(ref as UserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _UserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProviderElement extends AutoDisposeFutureProviderElement<UserModel?>
    with UserRef {
  _UserProviderElement(super.provider);

  @override
  String get userId => (origin as UserProvider).userId;
}

String _$userSearchHash() => r'caa516e0b847b5fce2e3b6a8da0d254b85f5054c';

/// See also [userSearch].
@ProviderFor(userSearch)
const userSearchProvider = UserSearchFamily();

/// See also [userSearch].
class UserSearchFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [userSearch].
  const UserSearchFamily();

  /// See also [userSearch].
  UserSearchProvider call(
    String query,
  ) {
    return UserSearchProvider(
      query,
    );
  }

  @override
  UserSearchProvider getProviderOverride(
    covariant UserSearchProvider provider,
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
  String? get name => r'userSearchProvider';
}

/// See also [userSearch].
class UserSearchProvider extends AutoDisposeStreamProvider<List<UserModel>> {
  /// See also [userSearch].
  UserSearchProvider(
    String query,
  ) : this._internal(
          (ref) => userSearch(
            ref as UserSearchRef,
            query,
          ),
          from: userSearchProvider,
          name: r'userSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSearchHash,
          dependencies: UserSearchFamily._dependencies,
          allTransitiveDependencies:
              UserSearchFamily._allTransitiveDependencies,
          query: query,
        );

  UserSearchProvider._internal(
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
    Stream<List<UserModel>> Function(UserSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserSearchProvider._internal(
        (ref) => create(ref as UserSearchRef),
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
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _UserSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSearchProvider && other.query == query;
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
mixin UserSearchRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _UserSearchProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with UserSearchRef {
  _UserSearchProviderElement(super.provider);

  @override
  String get query => (origin as UserSearchProvider).query;
}

String _$allUsersHash() => r'58b0cca7acc9585af2bc6e97e251a129cb8e3dd8';

/// See also [allUsers].
@ProviderFor(allUsers)
final allUsersProvider = AutoDisposeFutureProvider<List<UserModel>>.internal(
  allUsers,
  name: r'allUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllUsersRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$selectedUsersHash() => r'48d620e60f1fc43b3248aa0f7723055340cba8e1';

/// See also [SelectedUsers].
@ProviderFor(SelectedUsers)
final selectedUsersProvider =
    AutoDisposeNotifierProvider<SelectedUsers, Set<UserModel>>.internal(
  SelectedUsers.new,
  name: r'selectedUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedUsers = AutoDisposeNotifier<Set<UserModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
