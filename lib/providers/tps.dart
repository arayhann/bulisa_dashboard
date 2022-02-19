import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Tps {
  Tps({
    required this.id,
    required this.status,
    required this.tpsAddress,
    required this.tpsGeom,
    required this.tpsOwner,
    required this.tpsPhoneNumber,
  });

  int id;
  bool status;
  String tpsAddress;
  List<double> tpsGeom;
  String tpsOwner;
  dynamic tpsPhoneNumber;

  factory Tps.fromJson(Map<String, dynamic> json) => Tps(
        id: json["id"],
        status: json["status"],
        tpsAddress: json["tps_address"],
        tpsGeom: List<double>.from(json["tps_geom"].map((x) => x.toDouble())),
        tpsOwner: json["tps_owner"],
        tpsPhoneNumber: json["tps_phone_number"],
      );
}

final tpsDataProvider = StateNotifierProvider<TpsNotifier, List<Tps>>((ref) {
  return TpsNotifier();
});

class TpsNotifier extends StateNotifier<List<Tps>> {
  TpsNotifier() : super([]);

  List<Tps> get tpsData {
    return [...state];
  }

  Future<void> getTpsData(int limit, int offset, HasuraConnect hasuraConnect,
      String filterByName) async {
    final docQuery = """
query MyQuery {
  tps(order_by: {id: asc}, limit: $limit, offset: ${offset * limit} ${filterByName.isNotEmpty ? ', where: {id: {_eq: $filterByName}}' : ''}) {
    id
    status
    tps_address
    tps_geom
    tps_owner
    tps_phone_number
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['tps'];

    final List<Tps> loadedData = [];

    (responseData as List<dynamic>).forEach((tps) {
      loadedData.add(Tps.fromJson(tps));
    });

    state = loadedData;
  }

  Future<void> getMoreTpsData(int limit, int offset,
      HasuraConnect hasuraConnect, String filterByName) async {
    final docQuery = """
query MyQuery {
  tps(order_by: {id: asc}, limit: $limit, offset: ${offset * limit} ${filterByName.isNotEmpty ? ', where: {id: {_eq: $filterByName}}' : ''}) {
    id
    status
    tps_address
    tps_geom
    tps_owner
    tps_phone_number
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['tps'];

    final List<Tps> loadedData = state;

    (responseData as List<dynamic>).forEach((tps) {
      loadedData.add(Tps.fromJson(tps));
    });

    state = loadedData;
  }

  Future<void> editTpsStatus(
      bool newStatus, int id, HasuraConnect hasuraConnect) async {
    final docMutation = """
mutation MyMutation {
  update_tps_by_pk(pk_columns: {id: $id}, _set: {status: $newStatus}) {
    id
    status
    tps_address
    tps_geom
    tps_owner
    tps_phone_number
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);

    print(response);

    List<Tps> currentTps = [];

    state.forEach((tps) {
      if (tps.id == id) {
        currentTps.add(Tps.fromJson(response['data']['update_tps_by_pk']));
      } else {
        currentTps.add(tps);
      }
    });

    state = [...currentTps];
  }
}
