part of auth_models;

abstract class AppUser implements Built<AppUser, AppUserBuilder> {
  factory AppUser([void Function(AppUserBuilder b) updates]) = _$AppUser;

  factory AppUser.fromJson(dynamic json) => serializers.deserializeWith(serializer, json);

  AppUser._();

  String get uid;

  String get email;

  String get username;

  BuiltList<String> get following;

  BuiltList<String> get searchIndex;

  @nullable
  String get photoUrl;

  Map<String, dynamic> get json => serializers.serializeWith(serializer, this) as Map<String, dynamic>;

  static Serializer<AppUser> get serializer => _$appUserSerializer;
}
