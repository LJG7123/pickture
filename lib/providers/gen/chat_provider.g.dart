// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatServiceHash() => r'065f56d4c78e1b62f862485c25853747ac7c63dd';

/// See also [chatService].
@ProviderFor(chatService)
final chatServiceProvider = AutoDisposeProvider<ChatService>.internal(
  chatService,
  name: r'chatServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatServiceRef = AutoDisposeProviderRef<ChatService>;
String _$chatRoomsHash() => r'f0e4b84f4fa87089143461572fc27deb0ed25596';

/// See also [chatRooms].
@ProviderFor(chatRooms)
final chatRoomsProvider = AutoDisposeStreamProvider<List<ChatRoom>>.internal(
  chatRooms,
  name: r'chatRoomsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRoomsRef = AutoDisposeStreamProviderRef<List<ChatRoom>>;
String _$chatRoomHash() => r'8b59c49bd7ce2e2e05b5e7f9965175e301d2a92d';

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

/// See also [chatRoom].
@ProviderFor(chatRoom)
const chatRoomProvider = ChatRoomFamily();

/// See also [chatRoom].
class ChatRoomFamily extends Family<AsyncValue<ChatRoom>> {
  /// See also [chatRoom].
  const ChatRoomFamily();

  /// See also [chatRoom].
  ChatRoomProvider call(
    String chatId,
  ) {
    return ChatRoomProvider(
      chatId,
    );
  }

  @override
  ChatRoomProvider getProviderOverride(
    covariant ChatRoomProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatRoomProvider';
}

/// See also [chatRoom].
class ChatRoomProvider extends AutoDisposeFutureProvider<ChatRoom> {
  /// See also [chatRoom].
  ChatRoomProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatRoom(
            ref as ChatRoomRef,
            chatId,
          ),
          from: chatRoomProvider,
          name: r'chatRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomHash,
          dependencies: ChatRoomFamily._dependencies,
          allTransitiveDependencies: ChatRoomFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    FutureOr<ChatRoom> Function(ChatRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomProvider._internal(
        (ref) => create(ref as ChatRoomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChatRoom> createElement() {
    return _ChatRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatRoomRef on AutoDisposeFutureProviderRef<ChatRoom> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatRoomProviderElement
    extends AutoDisposeFutureProviderElement<ChatRoom> with ChatRoomRef {
  _ChatRoomProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatRoomProvider).chatId;
}

String _$chatRoomUserHash() => r'28bc85dd2bcf90c8ee2c1d9e0aecb3d9389e9622';

/// See also [chatRoomUser].
@ProviderFor(chatRoomUser)
const chatRoomUserProvider = ChatRoomUserFamily();

/// See also [chatRoomUser].
class ChatRoomUserFamily extends Family<AsyncValue<UserModel?>> {
  /// See also [chatRoomUser].
  const ChatRoomUserFamily();

  /// See also [chatRoomUser].
  ChatRoomUserProvider call(
    ChatRoom chatRoom,
  ) {
    return ChatRoomUserProvider(
      chatRoom,
    );
  }

  @override
  ChatRoomUserProvider getProviderOverride(
    covariant ChatRoomUserProvider provider,
  ) {
    return call(
      provider.chatRoom,
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
  String? get name => r'chatRoomUserProvider';
}

/// See also [chatRoomUser].
class ChatRoomUserProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// See also [chatRoomUser].
  ChatRoomUserProvider(
    ChatRoom chatRoom,
  ) : this._internal(
          (ref) => chatRoomUser(
            ref as ChatRoomUserRef,
            chatRoom,
          ),
          from: chatRoomUserProvider,
          name: r'chatRoomUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomUserHash,
          dependencies: ChatRoomUserFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomUserFamily._allTransitiveDependencies,
          chatRoom: chatRoom,
        );

  ChatRoomUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatRoom,
  }) : super.internal();

  final ChatRoom chatRoom;

  @override
  Override overrideWith(
    FutureOr<UserModel?> Function(ChatRoomUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomUserProvider._internal(
        (ref) => create(ref as ChatRoomUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatRoom: chatRoom,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _ChatRoomUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomUserProvider && other.chatRoom == chatRoom;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatRoom.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatRoomUserRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `chatRoom` of this provider.
  ChatRoom get chatRoom;
}

class _ChatRoomUserProviderElement
    extends AutoDisposeFutureProviderElement<UserModel?> with ChatRoomUserRef {
  _ChatRoomUserProviderElement(super.provider);

  @override
  ChatRoom get chatRoom => (origin as ChatRoomUserProvider).chatRoom;
}

String _$messagesHash() => r'36c0c3b6c88ad6dfbc5adc218e720f5548ae2620';

/// See also [messages].
@ProviderFor(messages)
const messagesProvider = MessagesFamily();

/// See also [messages].
class MessagesFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [messages].
  const MessagesFamily();

  /// See also [messages].
  MessagesProvider call(
    String chatId,
  ) {
    return MessagesProvider(
      chatId,
    );
  }

  @override
  MessagesProvider getProviderOverride(
    covariant MessagesProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'messagesProvider';
}

/// See also [messages].
class MessagesProvider extends StreamProvider<List<Message>> {
  /// See also [messages].
  MessagesProvider(
    String chatId,
  ) : this._internal(
          (ref) => messages(
            ref as MessagesRef,
            chatId,
          ),
          from: messagesProvider,
          name: r'messagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messagesHash,
          dependencies: MessagesFamily._dependencies,
          allTransitiveDependencies: MessagesFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  MessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<List<Message>> Function(MessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessagesProvider._internal(
        (ref) => create(ref as MessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  StreamProviderElement<List<Message>> createElement() {
    return _MessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessagesRef on StreamProviderRef<List<Message>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _MessagesProviderElement extends StreamProviderElement<List<Message>>
    with MessagesRef {
  _MessagesProviderElement(super.provider);

  @override
  String get chatId => (origin as MessagesProvider).chatId;
}

String _$chatRoomControllerHash() =>
    r'ffd7c7ab22227baf384f7697b4d8003aab12dd1b';

abstract class _$ChatRoomController
    extends BuildlessAutoDisposeAsyncNotifier<UserModel?> {
  late final String chatId;

  FutureOr<UserModel?> build(
    String chatId,
  );
}

/// See also [ChatRoomController].
@ProviderFor(ChatRoomController)
const chatRoomControllerProvider = ChatRoomControllerFamily();

/// See also [ChatRoomController].
class ChatRoomControllerFamily extends Family<AsyncValue<UserModel?>> {
  /// See also [ChatRoomController].
  const ChatRoomControllerFamily();

  /// See also [ChatRoomController].
  ChatRoomControllerProvider call(
    String chatId,
  ) {
    return ChatRoomControllerProvider(
      chatId,
    );
  }

  @override
  ChatRoomControllerProvider getProviderOverride(
    covariant ChatRoomControllerProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatRoomControllerProvider';
}

/// See also [ChatRoomController].
class ChatRoomControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChatRoomController, UserModel?> {
  /// See also [ChatRoomController].
  ChatRoomControllerProvider(
    String chatId,
  ) : this._internal(
          () => ChatRoomController()..chatId = chatId,
          from: chatRoomControllerProvider,
          name: r'chatRoomControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomControllerHash,
          dependencies: ChatRoomControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomControllerFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatRoomControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  FutureOr<UserModel?> runNotifierBuild(
    covariant ChatRoomController notifier,
  ) {
    return notifier.build(
      chatId,
    );
  }

  @override
  Override overrideWith(ChatRoomController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomControllerProvider._internal(
        () => create()..chatId = chatId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatRoomController, UserModel?>
      createElement() {
    return _ChatRoomControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomControllerProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatRoomControllerRef on AutoDisposeAsyncNotifierProviderRef<UserModel?> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatRoomControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatRoomController,
        UserModel?> with ChatRoomControllerRef {
  _ChatRoomControllerProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatRoomControllerProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
