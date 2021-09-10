import 'package:bulisa_dashboard/components/bordered_button.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/components/tab_button.dart';
import 'package:bulisa_dashboard/pages/home_page.dart';
import 'package:bulisa_dashboard/pages/orders_page.dart';
import 'package:bulisa_dashboard/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WorkInTab {
  final String title;
  final Icon icon;
  final Widget page;

  WorkInTab({
    required this.title,
    required this.icon,
    required this.page,
  });
}

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isExpand = useState(false);
    final _activeTabIndex = useState(0);

    final _goToDetailRoom = useMemoized(
        () => (int index) {
              _activeTabIndex.value = index;
            },
        []);

    final _tabs = [
      WorkInTab(
        title: 'Beranda',
        icon: Icon(
          Icons.home_filled,
          color: const Color(0xFF4D4D4D),
        ),
        page: HomePage(),
      ),
      WorkInTab(
        title: 'Daftar Pesanan',
        icon: Icon(
          Icons.format_list_bulleted_rounded,
          color: const Color(0xFF4D4D4D),
        ),
        page: OrdersPage(),
      ),
      WorkInTab(
        title: 'Daftar User',
        icon: Icon(
          Icons.person,
          color: const Color(0xFF4D4D4D),
        ),
        page: UsersPage(),
      ),
    ];

    final _tabAnimationTransition =
        useAnimationController(duration: const Duration(milliseconds: 500));
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            width: _isExpand.value ? 272 : 54,
            color: const Color(0xFF203288),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 27),
            duration: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      _isExpand.value = !_isExpand.value;
                      if (_isExpand.value) {
                        _tabAnimationTransition.forward();
                      } else {
                        _tabAnimationTransition.reverse();
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Image.asset(
                            'assets/img-logo-only-white.png',
                            width: 30,
                          ),
                        ),
                        if (_isExpand.value)
                          Expanded(
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _tabAnimationTransition,
                                curve: Interval(
                                  0.5,
                                  1,
                                  curve: Curves.easeIn,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  'BuLiSa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    TabButton(
                      title: 'Beranda',
                      icon: Icon(
                        Icons.home_filled,
                        color: Colors.white,
                      ),
                      isActive: _activeTabIndex.value == 0,
                      isExpand: _isExpand.value,
                      tabAnimationController: _tabAnimationTransition,
                      onPressed: () {
                        _activeTabIndex.value = 0;
                      },
                    ),
                    TabButton(
                      title: 'Daftar Pesanan',
                      icon: Icon(
                        Icons.format_list_bulleted_rounded,
                        color: Colors.white,
                      ),
                      isActive: _activeTabIndex.value == 1,
                      isExpand: _isExpand.value,
                      tabAnimationController: _tabAnimationTransition,
                      onPressed: () {
                        _activeTabIndex.value = 1;
                      },
                    ),
                    TabButton(
                      title: 'Daftar User',
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      isActive: _activeTabIndex.value == 2,
                      isExpand: _isExpand.value,
                      tabAnimationController: _tabAnimationTransition,
                      onPressed: () {
                        _activeTabIndex.value = 2;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: FillButton(
                              onTap: () {
                                _isExpand.value = !_isExpand.value;
                                if (_isExpand.value) {
                                  _tabAnimationTransition.forward();
                                } else {
                                  _tabAnimationTransition.reverse();
                                }
                              },
                              color: Colors.transparent,
                              child: Icon(
                                Icons.menu,
                                color: Color(0xFF4E4E4E),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            _tabs[_activeTabIndex.value].title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 100,
                        child: FillButton(
                          leading: Icon(
                            Icons.logout,
                            color: const Color(0xFF484848),
                          ),
                          text: "Log Out",
                          textColor: const Color(0xFF484848),
                          color: Colors.transparent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Log Out'),
                                content: Text('Apakah Anda yakin untuk logout'),
                                actionsPadding: const EdgeInsets.all(20),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FillButton(
                                          text: 'Tidak',
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: BorderedButton(
                                          text: 'Ya',
                                          color: const Color(0xFFFDC639),
                                          textColor: const Color(0xFFFDC639),
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _tabs[_activeTabIndex.value].page),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
