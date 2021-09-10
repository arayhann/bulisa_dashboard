import 'package:bulisa_dashboard/components/bordered_button.dart';
import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'drop_down_field.dart';

class DetailUserPopUP extends HookConsumerWidget {
  final int id;
  const DetailUserPopUP(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isLoading = useState(true);
    final _userData = useState<UserData?>(null);

    useEffect(() {
      ref
          .read(userDataProvider.notifier)
          .getUserDetailById(id, ref.read(hasuraClientProvider).state)
          .then((value) {
        _isLoading.value = false;
        _userData.value = value;
      });
      return;
    }, []);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: _isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Detail User',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 134,
                            width: 134,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: (_userData.value!.photoUrl!
                                        .contains('avatar')
                                    ? AssetImage(
                                        'assets/img-${_userData.value!.photoUrl}.png')
                                    : NetworkImage(_userData
                                        .value!.photoUrl!)) as ImageProvider,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama User',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('${_userData.value!.name}'),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('${_userData.value!.email}'),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'No Hp',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('${_userData.value!.phoneNumber}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('${_userData.value!.address}'),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: double.infinity,
                        height: 136,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(
                              _userData.value!.geom == null
                                  ? 'https://www.unas.ac.id/wp-content/uploads/2021/08/placeholder-29-768x512.png'
                                  : 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${_userData.value!.geom![1]},${_userData.value!.geom![0]},15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 87,
                            child: BorderedButton(
                              text: 'Tutup',
                              color: const Color(0xFFFDC639),
                              textColor: const Color(0xFFFDC639),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
