import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/product_list_cubit/product_list_cubit.dart';
import 'package:scanner_app/cubit/session_cubit/session_cubit.dart';
import 'package:scanner_app/screens/home_screen/pages/scanned_page.dart';
import 'package:scanner_app/screens/home_screen/pages/unscanned_page.dart';
import 'package:scanner_app/screens/home_screen/widgets/menu_drawer.dart';

import 'widgets/history_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static final ValueNotifier<bool> isSearching = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () {
          if (isSearching.value == true) {
            isSearching.value = false;
            context.read<ProductListCubit>().getQueriedProductList("");
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Image(
                height: kToolbarHeight * 0.8,
                image: AssetImage('assets/logo.png'),
              ),
            ),
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: 'Menu',
                icon: const Icon(Icons.menu_rounded),
                color: Colors.black,
              );
            }),
            actions: [
              BlocBuilder<SessionCubit, SessionState>(
                buildWhen: (previous, current) {
                  if (current is SessionLoaded) {
                    if (current.actualSession == null) {
                      return true;
                    }
                    if (previous is SessionLoaded) {
                      if (previous.actualSession == null &&
                          current.actualSession != null) {
                        return true;
                      }
                    }
                  }
                  return false;
                },
                builder: (context, state) {
                  return ValueListenableBuilder(
                      valueListenable: isSearching,
                      builder: (context, bool listenable, child) {
                        return IconButton(
                          onPressed: (state is SessionLoaded &&
                                  state.actualSession != null)
                              ? () {
                                  isSearching.value = !isSearching.value;
                                  if (isSearching.value == false) {
                                    context
                                        .read<ProductListCubit>()
                                        .getQueriedProductList("");
                                  }
                                }
                              : null,
                          tooltip: 'Search',
                          icon: listenable
                              ? const Icon(
                                  Icons.search_off_rounded,
                                  color: Color(0xFFFF4444),
                                )
                              : const Icon(Icons.search_rounded),
                          color: Colors.black,
                        );
                      });
                },
              ),
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip: "History",
                  icon: const Icon(Icons.history_rounded),
                  color: Colors.black,
                );
              }),
            ],
            bottom: const TabBar(
              indicatorColor: Color(0xFFA4C422),
              labelColor: Colors.black,
              tabs: [
                Tab(text: 'Niezeskanowane'),
                Tab(text: 'Zeskanowane'),
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<SessionCubit, SessionState>(
            buildWhen: (previous, current) {
              if (current is SessionLoaded) {
                if (current.actualSession == null) {
                  return true;
                }
                if (previous is SessionLoaded) {
                  if (previous.actualSession == null &&
                      current.actualSession != null) {
                    return true;
                  }
                }
              }
              return false;
            },
            builder: (context, state) {
              if (state is SessionLoaded && state.actualSession != null) {
                return ValueListenableBuilder(
                  valueListenable: isSearching,
                  builder: (context, bool isSearching, child) {
                    return isSearching
                        ? const SizedBox()
                        : FloatingActionButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, '/scanner');
                            },
                            tooltip: 'Scan',
                            backgroundColor: const Color(0xFFA4C422),
                            child: const Icon(Icons.document_scanner_rounded),
                          );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          drawer: const MenuDrawer(),
          endDrawer: const HistoryDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: TabBarView(
                  children: [
                    UnscannedPage(),
                    ScannedPage(),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: isSearching,
                builder: (context, bool isSearching, child) {
                  if (isSearching == true) {
                    return const SearchBar();
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          context.read<ProductListCubit>().getQueriedProductList(value);
          setState(() {});
        },
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.black,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    context.read<ProductListCubit>().getQueriedProductList("");
                    setState(() {
                      _controller.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                  ),
                ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFA4C422))),
          hintText: 'Wyszukaj produkt',
        ),
      ),
    );
  }
}
