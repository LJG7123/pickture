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

String _$chatRoomHash() => r'6bba1f3a6a7edcc6d237a5d313f4f9b371091a68';

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

String _$createChatRoomHash() => r'bf41d3efb57e61b64eb97ebecaf2684cad178f99';

/// See also [createChatRoom].
@ProviderFor(createChatRoom)
const createChatRoomProvider = CreateChatRoomFamily();

/// See also [createChatRoom].
class CreateChatRoomFamily extends Family<AsyncValue<ChatRoom>> {
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
class CreateChatRoomProvider extends AutoDisposeFutureProvider<ChatRoom> {
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
    FutureOr<ChatRoom> Function(CreateChatRoomRef provider) create,
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
  AutoDisposeFutureProviderElement<ChatRoom> createElement() {
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
mixin CreateChatRoomRef on AutoDisposeFutureProviderRef<ChatRoom> {
  /// The parameter `params` of this provider.
  ({String? groupName, List<String> participants}) get params;
}

class _CreateChatRoomProviderElement
    extends AutoDisposeFutureProviderElement<ChatRoom> with CreateChatRoomRef {
  _CreateChatRoomProviderElement(super.provider);

  @override
  ({String? groupName, List<String> participants}) get params =>
      (origin as CreateChatRoomProvider).params;
}

String _$chatRoomUserHash() => r'3efc0adfb46cce2450cee60a6c320fa5da698fce';

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

String _$sendMessageHash() => r'3316207ec99ee434ac12f85f6a8a606d17e1dc67';

/// See also [sendMessage].
@ProviderFor(sendMessage)
const sendMessageProvider = SendMessageFamily();

/// See also [sendMessage].
class SendMessageFamily extends Family<AsyncValue<void>> {
  /// See also [sendMessage].
  const SendMessageFamily();

  /// See also [sendMessage].
  SendMessageProvider call(
    ({String chatId, String content, String senderId}) params,
  ) {
    return SendMessageProvider(
      params,
    );
  }

  @override
  SendMessageProvider getProviderOverride(
    covariant SendMessageProvider provider,
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
  String? get name => r'sendMessageProvider';
}

/// See also [sendMessage].
class SendMessageProvider extends AutoDisposeFutureProvider<void> {
  /// See also [sendMessage].
  SendMessageProvider(
    ({String chatId, String content, String senderId}) params,
  ) : this._internal(
          (ref) => sendMessage(
            ref as SendMessageRef,
            params,
          ),
          from: sendMessageProvider,
          name: r'sendMessageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sendMessageHash,
          dependencies: SendMessageFamily._dependencies,
          allTransitiveDependencies:
              SendMessageFamily._allTransitiveDependencies,
          params: params,
        );

  SendMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ({String chatId, String content, String senderId}) params;

  @override
  Override overrideWith(
    FutureOr<void> Function(SendMessageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SendMessageProvider._internal(
        (ref) => create(ref as SendMessageRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SendMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SendMessageProvider && other.params == params;
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
mixin SendMessageRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `params` of this provider.
  ({String chatId, String content, String senderId}) get params;
}

class _SendMessageProviderElement extends AutoDisposeFutureProviderElement<void>
    with SendMessageRef {
  _SendMessageProviderElement(super.provider);

  @override
  ({String chatId, String content, String senderId}) get params =>
      (origin as SendMessageProvider).params;
}

String _$chatRoomWithUserHash() => r'5bd06f504bff8d9cd4a8b52259ae6c98d83f2f58';

/// See also [chatRoomWithUser].
@ProviderFor(chatRoomWithUser)
const chatRoomWithUserProvider = ChatRoomWithUserFamily();

/// See also [chatRoomWithUser].
class ChatRoomWithUserFamily
    extends Family<AsyncValue<({ChatRoom chatRoom, UserModel? otherUser})>> {
  /// See also [chatRoomWithUser].
  const ChatRoomWithUserFamily();

  /// See also [chatRoomWithUser].
  ChatRoomWithUserProvider call(
    String chatId,
  ) {
    return ChatRoomWithUserProvider(
      chatId,
    );
  }

  @override
  ChatRoomWithUserProvider getProviderOverride(
    covariant ChatRoomWithUserProvider provider,
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
  String? get name => r'chatRoomWithUserProvider';
}

/// See also [chatRoomWithUser].
class ChatRoomWithUserProvider extends AutoDisposeFutureProvider<
    ({ChatRoom chatRoom, UserModel? otherUser})> {
  /// See also [chatRoomWithUser].
  ChatRoomWithUserProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatRoomWithUser(
            ref as ChatRoomWithUserRef,
            chatId,
          ),
          from: chatRoomWithUserProvider,
          name: r'chatRoomWithUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomWithUserHash,
          dependencies: ChatRoomWithUserFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomWithUserFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatRoomWithUserProvider._internal(
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
    FutureOr<({ChatRoom chatRoom, UserModel? otherUser})> Function(
            ChatRoomWithUserRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomWithUserProvider._internal(
        (ref) => create(ref as ChatRoomWithUserRef),
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
  AutoDisposeFutureProviderElement<({ChatRoom chatRoom, UserModel? otherUser})>
      createElement() {
    return _ChatRoomWithUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomWithUserProvider && other.chatId == chatId;
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
mixin ChatRoomWithUserRef on AutoDisposeFutureProviderRef<
    ({ChatRoom chatRoom, UserModel? otherUser})> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatRoomWithUserProviderElement extends AutoDisposeFutureProviderElement<
    ({ChatRoom chatRoom, UserModel? otherUser})> with ChatRoomWithUserRef {
  _ChatRoomWithUserProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatRoomWithUserProvider).chatId;
}

String _$messageUserIdsHash() => r'73263b3565faa8c45aff4a361035cd7483b2d472';

/// See also [MessageUserIds].
@ProviderFor(MessageUserIds)
final messageUserIdsProvider =
    AutoDisposeNotifierProvider<MessageUserIds, Set<String>>.internal(
  MessageUserIds.new,
  name: r'messageUserIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messageUserIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MessageUserIds = AutoDisposeNotifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
