import 'dart:convert';

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
  });

  int id;
  String weight;
  String address;
  String method;
  DateTime createdAt;
  String status;
  List<double>? geom;
  String? photoUrl;
  String? orderName;
  String? orderPhoneNumber;
  String? price;

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
      );
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  Future<void> getOrders(
      int limit, int offset, HasuraConnect hasuraConnect) async {
    final docQuery = """
query MyQuery {
  order(limit: 10, offset: 0, order_by: {created_at: desc}) {
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

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data']['order'];

    final List<Order> loadedData = [];

    print(responseData);

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
}
