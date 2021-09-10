import 'package:bulisa_dashboard/providers/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hasuraClientProvider = StateProvider<HasuraConnect>(
  (ref) {
    return HasuraConnect(
      'https://bulisa-production.hasura.app/v1/graphql',
      interceptors: [TokenInterceptor(ref.watch(authProvider), ref)],
    );
  },
);

class TokenInterceptor extends Interceptor {
  final String token;
  final ProviderRefBase ref;

  TokenInterceptor(this.token, this.ref);

  @override
  Future<void> onConnected(HasuraConnect connect) {
    throw UnimplementedError();
  }

  @override
  Future<void> onDisconnected() {
    throw UnimplementedError();
  }

  @override
  Future onError(HasuraError request) async {
    Fluttertoast.showToast(
      msg: request.message,
    );

    return request.message;
  }

  @override
  Future onRequest(Request request) async {
    if (token.isEmpty) {
      return request;
    } else {
      try {
        request.headers["Authorization"] = "Bearer $token";
        return request;
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future onResponse(Response data) async {
    return data;
  }

  @override
  Future<void> onSubscription(Request request, Snapshot snapshot) {
    throw UnimplementedError();
  }

  @override
  Future<void> onTryAgain(HasuraConnect connect) {
    throw UnimplementedError();
  }
}
