// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatServiceHash() => r'b9998fa2d42956e2e80a1f29370868db8f5e1c22';

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
String _$chatRoomsHash() => r'cf8defeb7755de4da483690547e14b64eb946ce4';

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

/// See also [chatRooms].
@ProviderFor(chatRooms)
const chatRoomsProvider = ChatRoomsFamily();

/// See also [chatRooms].
class ChatRoomsFamily extends Family<AsyncValue<List<ChatRoom>>> {
  /// See also [chatRooms].
  const ChatRoomsFamily();

  /// See also [chatRooms].
  ChatRoomsProvider call(
    String userId,
  ) {
    return ChatRoomsProvider(
      userId,
    );
  }

  @override
  ChatRoomsProvider getProviderOverride(
    covariant ChatRoomsProvider provider,
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
  String? get name => r'chatRoomsProvider';
}

/// See also [chatRooms].
class ChatRoomsProvider extends AutoDisposeStreamProvider<List<ChatRoom>> {
  /// See also [chatRooms].
  ChatRoomsProvider(
    String userId,
  ) : this._internal(
          (ref) => chatRooms(
            ref as ChatRoomsRef,
            userId,
          ),
          from: chatRoomsProvider,
          name: r'chatRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomsHash,
          dependencies: ChatRoomsFamily._dependencies,
          allTransitiveDependencies: ChatRoomsFamily._allTransitiveDependencies,
          userId: userId,
        );

  ChatRoomsProvider._internal(
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
    Stream<List<ChatRoom>> Function(ChatRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomsProvider._internal(
        (ref) => create(ref as ChatRoomsRef),
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
  AutoDisposeStreamProviderElement<List<ChatRoom>> createElement() {
    return _ChatRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomsProvider && other.userId == userId;
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
mixin ChatRoomsRef on AutoDisposeStreamProviderRef<List<ChatRoom>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ChatRoomsProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatRoom>> with ChatRoomsRef {
  _ChatRoomsProviderElement(super.provider);

  @override
  String get userId => (origin as ChatRoomsProvider).userId;
}

String _$chatRoomHash() => r'104c5ccfe087a24ad9abbe5c4509a23b45633a1c';

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

String _$messagesHash() => r'13ef6327615a5fcef7e232feb8a7e06178785639';

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
class MessagesProvider extends AutoDisposeStreamProvider<List<Message>> {
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
  AutoDisposeStreamProviderElement<List<Message>> createElement() {
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
mixin MessagesRef on AutoDisposeStreamProviderRef<List<Message>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _MessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<Message>> with MessagesRef {
  _MessagesProviderElement(super.provider);

  @override
  String get chatId => (origin as MessagesProvider).chatId;
}

String _$createChatRoomHash() => r'94d8a842033f12b78a074342cf456da1994b46da';

/// See also [createChatRoom].
@ProviderFor(createChatRoom)
const createChatRoomProvider = CreateChatRoomFamily();

/// See also [createChatRoom].
class CreateChatRoomFamily extends Family<AsyncValue<String>> {
  /// See also [createChatRoom].
  const CreateChatRoomFamily();

  /// See also [createChatRoom].
  CreateChatRoomProvider call(
    ({String? groupName, List<String> participants}) params,
  ) {
    return CreateChatRoomProvider(
      params,
    );
  }

  @override
  CreateChatRoomProvider getProviderOverride(
    covariant CreateChatRoomProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'createChatRoomProvider';
}

/// See also [createChatRoom].
class CreateChatRoomProvider extends AutoDisposeFutureProvider<String> {
  /// See also [createChatRoom].
  CreateChatRoomProvider(
    ({String? groupName, List<String> participants}) params,
  ) : this._internal(
          (ref) => createChatRoom(
            ref as CreateChatRoomRef,
            params,
          ),
          from: createChatRoomProvider,
          name: r'createChatRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createChatRoomHash,
          dependencies: CreateChatRoomFamily._dependencies,
          allTransitiveDependencies:
              CreateChatRoomFamily._allTransitiveDependencies,
          params: params,
        );

  CreateChatRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ({String? groupName, List<String> participants}) params;

  @override
  Override overrideWith(
    FutureOr<String> Function(CreateChatRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateChatRoomProvider._internal(
        (ref) => create(ref as CreateChatRoomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _CreateChatRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateChatRoomProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateChatRoomRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `params` of this provider.
  ({String? groupName, List<String> participants}) get params;
}

class _CreateChatRoomProviderElement
    extends AutoDisposeFutureProviderElement<String> with CreateChatRoomRef {
  _CreateChatRoomProviderElement(super.provider);

  @override
  ({String? groupName, List<String> participants}) get params =>
      (origin as CreateChatRoomProvider).params;
}

String _$startChatWithUserHash() => r'efaab1b805192f4bf6f5559b1052c91d4e093fe5';

/// See also [startChatWithUser].
@ProviderFor(startChatWithUser)
const startChatWithUserProvider = StartChatWithUserFamily();

/// See also [startChatWithUser].
class StartChatWithUserFamily extends Family<AsyncValue<String>> {
  /// See also [startChatWithUser].
  const StartChatWithUserFamily();

  /// See also [startChatWithUser].
  StartChatWithUserProvider call(
    String otherUserId,
  ) {
    return StartChatWithUserProvider(
      otherUserId,
    );
  }

  @override
  StartChatWithUserProvider getProviderOverride(
    covariant StartChatWithUserProvider provider,
  ) {
    return call(
      provider.otherUserId,
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
  String? get name => r'startChatWithUserProvider';
}

/// See also [startChatWithUser].
class StartChatWithUserProvider extends AutoDisposeFutureProvider<String> {
  /// See also [startChatWithUser].
  StartChatWithUserProvider(
    String otherUserId,
  ) : this._internal(
          (ref) => startChatWithUser(
            ref as StartChatWithUserRef,
            otherUserId,
          ),
          from: startChatWithUserProvider,
          name: r'startChatWithUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$startChatWithUserHash,
          dependencies: StartChatWithUserFamily._dependencies,
          allTransitiveDependencies:
              StartChatWithUserFamily._allTransitiveDependencies,
          otherUserId: otherUserId,
        );

  StartChatWithUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.otherUserId,
  }) : super.internal();

  final String otherUserId;

  @override
  Override overrideWith(
    FutureOr<String> Function(StartChatWithUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StartChatWithUserProvider._internal(
        (ref) => create(ref as StartChatWithUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        otherUserId: otherUserId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _StartChatWithUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StartChatWithUserProvider &&
        other.otherUserId == otherUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StartChatWithUserRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `otherUserId` of this provider.
  String get otherUserId;
}

class _StartChatWithUserProviderElement
    extends AutoDisposeFutureProviderElement<String> with StartChatWithUserRef {
  _StartChatWithUserProviderElement(super.provider);

  @override
  String get otherUserId => (origin as StartChatWithUserProvider).otherUserId;
}

String _$chatRoomUserHash() => r'7a1d4770e6a316432bcbe8c22280aa8b758570a2';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
