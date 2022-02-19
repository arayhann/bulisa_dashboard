import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Order {
  Order({
    required this.id,
    required this.weight,
    required this.address,
    required this.method,
    required this.createdAt,
    required this.status,
    this.geom,
    this.photoUrl,
    this.orderName,
    this.orderPhoneNumber,
    this.price,
    this.tpsId,
  });

  int id;
  int weight;
  String address;
  String method;
  DateTime createdAt;
  String status;
  List<double>? geom;
  String? photoUrl;
  String? orderName;
  String? orderPhoneNumber;
  String? price;
  int? tpsId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        weight: json["weight"],
        address: json["address"],
        method: json["method"],
        createdAt: DateTime.parse(json["created_at"]),
        status: json["status"],
        geom: json["geom"] == null
            ? null
            : List<double>.from(json["geom"].map((x) => x.toDouble())),
        photoUrl: json["photo_url"],
        orderName: json["order_name"],
        orderPhoneNumber: json["order_phone_number"],
        price: json["price"],
        tpsId: json["tps_id"],
      );
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  List<Order> get orders {
    return [...state];
  }

  Future<void> getOrders(int limit, int offset, HasuraConnect hasuraConnect,
      String filterByName) async {
    final docQuery = """
query MyQuery {
  order(limit: $limit, offset: ${offset * limit}, order_by: {created_at: desc} ${filterByName.isNotEmpty ? ', where: {order_name: {_ilike: "$filterByName"}}' : ''}) {
    order_name
    weight
    address
    id
    method
    created_at
    status
    tps_id
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['order'];

    final List<Order> loadedData = [];

    (responseData as List<dynamic>).forEach((order) {
      loadedData.add(Order.fromJson(order));
    });

    state = loadedData;
  }

  Future<void> getMoreOrders(int limit, int offset, HasuraConnect hasuraConnect,
      String filterByName) async {
    final docQuery = """
query MyQuery {
  order(limit: $limit, offset: ${offset * limit}, order_by: {created_at: desc} ${filterByName.isNotEmpty ? ', where: {order_name: {_ilike: "$filterByName"}}' : ''}) {
    order_name
    weight
    address
    id
    method
    created_at
    status
    tps_id
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['order'];

    final List<Order> loadedData = state;

    (responseData as List<dynamic>).forEach((order) {
      loadedData.add(Order.fromJson(order));
    });

    state = loadedData;
  }

  Future<Order> getOrderById(int id, HasuraConnect hasuraConnect) async {
    final docQuery = """
query MyQuery {
  order_by_pk(id: $id) {
    address
    created_at
    geom
    id
    method
    photo_url
    status
    user_id
    weight
    order_name
    order_phone_number
    price
  }
}
""";

    final response = await hasuraConnect.query(docQuery);

    final responseData = response['data']['order_by_pk'];
    print(responseData);

    return Order.fromJson(responseData);
  }

  Future<void> createOrder(
      Map<String, dynamic> orderData, HasuraConnect hasuraConnect) async {
    final docMutation = """
mutation MyMutation(\$data: order_insert_input!) {
  insert_order_one(object: \$data) {
    id
    order_name
    weight
    address
    method
    created_at
    status
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation, variables: {
      'data': orderData,
    });

    List<Order> currentOrder = state;

    state = [
      ...currentOrder,
      Order.fromJson(response['data']['insert_order_one'])
    ];
  }

  Future<void> editOrder(Map<String, dynamic> orderData, int id,
      HasuraConnect hasuraConnect) async {
    final docMutation = """
mutation MyMutation(\$data: order_set_input!) {
  update_order_by_pk(pk_columns: {id: $id}, _set: \$data) {
    id
    order_name
    weight
    address
    method
    created_at
    status
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation, variables: {
      'data': orderData,
    });

    print(response);

    List<Order> currentOrder = [];

    state.forEach((order) {
      if (order.id == id) {
        currentOrder
            .add(Order.fromJson(response['data']['update_order_by_pk']));
      } else {
        currentOrder.add(order);
      }
    });

    state = [...currentOrder];
  }

  Future<void> deleteOrder(int id, HasuraConnect hasuraConnect) async {
    final docMutation = """
mutation MyMutation {
  delete_order_by_pk(id: $id) {
    id
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);

    print(response);

    List<Order> currentOrder = [];

    state.forEach((order) {
      if (order.id != id) {
        currentOrder.add(order);
      }
    });

    state = [...currentOrder];
  }

  Future<Map<String, int>> getOrderSummary(HasuraConnect hasuraConnect) async {
    final docQuery = """
query MyQuery {
  total_user: user_data_aggregate {
    aggregate {
      count
    }
  }
  total_weight: order_aggregate(where: {status: {_eq: "Selesai"}}) {
    aggregate {
      sum {
        weight
      }
    }
  }
}
""";

    final response = await hasuraConnect.query(docQuery);

    final responseData = response['data'];

    return {
      'total_user': responseData['total_user']['aggregate']['count'],
      'total_weight': responseData['total_weight']['aggregate']['sum']
          ['weight'],
    };
  }

  Future<int> getOrderPrice(HasuraConnect hasuraConnect) async {
    final docQuery = """
query MyQuery {
  user_data(limit: 1) {
    kg_price
  }
}
""";

    final response = await hasuraConnect.query(docQuery);

    final responseData = response['data'];

    return responseData['user_data'][0]['kg_price'];
  }

  Future<void> editOrderPrice(HasuraConnect hasuraConnect, int newPrice) async {
    final doc = """
mutation MyMutation {
  update_user_data(where: {}, _set: {kg_price: $newPrice}) {
    affected_rows
  }
}
""";

    final response = await hasuraConnect.mutation(doc);
  }
}
