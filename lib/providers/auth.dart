import 'package:hasura_connect/hasura_connect.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String> {
  AuthNotifier() : super('');

  bool get isAuth {
    return state.isNotEmpty;
  }

  bool tryAutoLogin() {
    final String? token = Hive.box('bulisa').get('token');

    if (token == null) {
      return false;
    }
    state = token;
    return true;
  }

  Future<void> login(Map<String, String> authData) async {
    String docQuery = """
query MyQuery {
  admin {
    is_admin
  }
}
""";

    final hasuraConnect = HasuraConnect(
        'https://bulisa-production.hasura.app/v1/graphql',
        headers: {'x-hasura-admin-secret': authData['password']!});

    final response = await hasuraConnect.query(docQuery);

    final box = Hive.box('bulisa');
    box.put('token', authData['password']);

    state = authData['password']!;
  }

  Future<void> signUp(
      Map<String, String> authData, HasuraConnect hasuraConnect) async {
    print(authData);

    String docMutation = """
mutation MyMutation {
  create_user(credentials: {email: "${authData['email']}", password: "${authData['password']}"}) {
    id
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);
    print(response);
  }

  void logout() async {
    state = '';
    final box = Hive.box('bulisa');
    box.delete('token');
  }
}
