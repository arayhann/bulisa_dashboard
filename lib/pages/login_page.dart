import 'dart:ui';

import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/pages/main_page.dart';
import 'package:bulisa_dashboard/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _size = MediaQuery.of(context).size;
    final _formKey = useState(GlobalKey<FormState>());
    final _authData = useState<Map<String, String>>({});
    final _isLoading = useState(false);

    final _submit = useMemoized(
      () => () async {
        if (!_formKey.value.currentState!.validate()) {
          return;
        }

        _formKey.value.currentState!.save();

        _isLoading.value = true;

        try {
          await ref.read(authProvider.notifier).login(
                _authData.value,
                ref.read(hasuraClientProvider).state,
              );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              (route) => false);
        } catch (error) {
          _isLoading.value = false;
          throw error;
        }
      },
    );
    return Scaffold(
      body: Form(
        key: _formKey.value,
        child: Stack(
          children: [
            Container(
              width: _size.width,
              height: _size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0x80DE463B), const Color(0x80CBD423)],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 808,
                height: 449,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  shadowColor: Colors.grey.withOpacity(0.1),
                  elevation: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF203288),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/img-logo-bg.png',
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Admin\nDashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const Text(
                                'Welcome to\nBuLiSa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 48,
                                ),
                              ),
                              const Text(
                                '© 2021 Bukan Limbah Biasa',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/img-logo1.png',
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('Email'),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  BorderedFormField(
                                    hint: 'Email',
                                    onSaved: (value) {
                                      if (value != null) {
                                        _authData.value['email'] = value;
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Email tidak boleh kosong';
                                      }
                                      if (value.isEmpty) {
                                        return 'Email tidak boleh kosong';
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text('Password'),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  BorderedFormField(
                                    hint: 'Password',
                                    obscureText: true,
                                    maxLine: 1,
                                    onSaved: (value) {
                                      if (value != null) {
                                        _authData.value['password'] = value;
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      if (value.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                    },
                                  ),
                                ],
                              ),
                              FillButton(
                                text: 'Sign In',
                                isLoading: _isLoading.value,
                                onTap: _submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
