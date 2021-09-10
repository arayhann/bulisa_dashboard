import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserData {
  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    this.geom,
    this.photoUrl,
  });

  int id;
  String name;
  String email;
  String phoneNumber;
  String address;
  DateTime createdAt;
  List<double>? geom;
  String? photoUrl;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        geom: json["geom"] == null
            ? null
            : List<double>.from(json["geom"].map((x) => x.toDouble())),
        photoUrl: json["photo_url"],
      );
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, List<UserData>>((ref) {
  return UserDataNotifier();
});

class UserDataNotifier extends StateNotifier<List<UserData>> {
  UserDataNotifier() : super([]);

  Future<void> getUserData(
      int limit, int offset, HasuraConnect hasuraConnect) async {
    final docQuery = """
query MyQuery {
  user_data(order_by: {created_at: asc}, limit: $limit, offset: $offset) {
    id
    name
    email
    phone_number
    address
    created_at
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['user_data'];

    final List<UserData> loadedData = [];

    print(responseData);

    (responseData as List<dynamic>).forEach((order) {
      loadedData.add(UserData.fromJson(order));
    });

    state = loadedData;
  }

  Future<UserData> getUserDetailById(
      int id, HasuraConnect hasuraConnect) async {
    final docQuery = """
query MyQuery {
  user_data_by_pk(id: $id) {
    address
    created_at
    email
    geom
    id
    name
    phone_number
    photo_url
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['user_data_by_pk'];

    return UserData.fromJson(responseData);
  }
}
