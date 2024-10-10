class UserState {
  final bool isLoading;
  final String? error;
  final List<Data> users;
  final int statusCode;
  final bool success;
  final List<String> messages;
  final List<Data> data;

  UserState({
    this.isLoading = false,
    this.error,
    required this.statusCode,
    required this.success,
    required this.messages,
    required this.data,
    List<Data>? users,
  }) : users = users ?? data;

  // Factory constructor for initial state
  factory UserState.initial() {
    return UserState(
      isLoading: false,
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  // Loading state factory
  factory UserState.loading() {
    return UserState(
      isLoading: true,
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  // Error state factory
  factory UserState.error(String errorMessage) {
    return UserState(
      isLoading: false,
      error: errorMessage,
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  UserState.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'],
        success = json['success'],
        messages = List.castFrom<dynamic, String>(json['messages']),
        data = json['data'] != null
            ? List.from(json['data']).map((e) => Data.fromJson(e)).toList()
            : [],
        isLoading = false,
        error = null,
        users = json['data'] != null
            ? List.from(json['data']).map((e) => Data.fromJson(e)).toList()
            : [];

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['success'] = success;
    _data['messages'] = messages;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }

  // CopyWith method for UserState
  UserState copyWith({
    bool? isLoading,
    String? error,
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? List.from(this.messages),
      data: data ?? List.from(this.data),
      users: data ?? List.from(this.users),
    );
  }
}

class Data {
  Data({
    required this.userId,
    this.username,
    this.countryname,
    this.state,
    this.city,
    this.address,
    this.profilePic,
    this.useRole,
    this.idFront,
    this.idBack,
    this.idCard,
    this.bankaccountno,
    this.bankname,
    this.ifsccode,
    this.latitude,
    this.longitude,
    this.radius,
    this.accessToken,
    this.accessTokenExpiresAt,
    this.refreshToken,
    this.refreshTokenExpiresAt,
    this.mobileno,
  });

  late final int userId;
  late final String? username;
  late final String? countryname;
  late final String? state;
  late final String? city;
  late final String? address;
  late final String? profilePic;
  late final String? useRole;
  late final String? idFront;
  late final String? idBack;
  late final String? idCard;
  late final String? bankaccountno;
  late final String? bankname;
  late final String? ifsccode;
  late final String? latitude;
  late final String? longitude;
  late final int? radius;
  late final String? accessToken;
  late final String? accessTokenExpiresAt;
  late final String? refreshToken;
  late final String? refreshTokenExpiresAt;
  late final String? mobileno;

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    countryname = json['countryname'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    profilePic = json['profile_pic'];
    useRole = json['use_role'];
    idFront = json['id_front'];
    idBack = json['id_back'];
    idCard = json['id_card'];
    bankaccountno = json['bankaccountno'];
    bankname = json['bankname'];
    ifsccode = json['ifsccode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    accessToken = json['access_token'];
    accessTokenExpiresAt = json['access_token_expires_at'];
    refreshToken = json['refresh_token'];
    refreshTokenExpiresAt = json['refresh_token_expires_at'];
    mobileno = json['mobileno'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['username'] = username;
    _data['countryname'] = countryname;
    _data['state'] = state;
    _data['city'] = city;
    _data['address'] = address;
    _data['profile_pic'] = profilePic;
    _data['use_role'] = useRole;
    _data['id_front'] = idFront;
    _data['id_back'] = idBack;
    _data['id_card'] = idCard;
    _data['bankaccountno'] = bankaccountno;
    _data['bankname'] = bankname;
    _data['ifsccode'] = ifsccode;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['radius'] = radius;
    _data['access_token'] = accessToken;
    _data['access_token_expires_at'] = accessTokenExpiresAt;
    _data['refresh_token'] = refreshToken;
    _data['refresh_token_expires_at'] = refreshTokenExpiresAt;
    _data['mobileno'] = mobileno;
    return _data;
  }

  // CopyWith method for Data
  Data copyWith({
    int? userId,
    String? username,
    String? countryname,
    String? state,
    String? city,
    String? address,
    String? profilePic,
    String? useRole,
    String? idFront,
    String? idBack,
    String? idCard,
    String? bankaccountno,
    String? bankname,
    String? ifsccode,
    String? latitude,
    String? longitude,
    int? radius,
    String? accessToken,
    String? accessTokenExpiresAt,
    String? refreshToken,
    String? refreshTokenExpiresAt,
    String? mobileno,
  }) {
    return Data(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      countryname: countryname ?? this.countryname,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      profilePic: profilePic ?? this.profilePic,
      useRole: useRole ?? this.useRole,
      idFront: idFront ?? this.idFront,
      idBack: idBack ?? this.idBack,
      idCard: idCard ?? this.idCard,
      bankaccountno: bankaccountno ?? this.bankaccountno,
      bankname: bankname ?? this.bankname,
      ifsccode: ifsccode ?? this.ifsccode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      accessToken: accessToken ?? this.accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpiresAt:
          refreshTokenExpiresAt ?? this.refreshTokenExpiresAt,
      mobileno: mobileno ?? this.mobileno,
    );
  }
}
