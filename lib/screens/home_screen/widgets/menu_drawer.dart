import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/session_cubit/session_cubit.dart';
import 'package:intl/intl.dart';

import '../../../cubit/product_list_cubit/product_list_cubit.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 5.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Color(0xEEA4C422),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statystyki sesji",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SessionCubit, SessionState>(
                      builder: (context, state) {
                        String? date;
                        int? editedProducts;
                        int? products;
                        int? process;

                        if (state is SessionLoaded &&
                            state.actualSession != null) {
                          date = DateFormat("dd.MM.yyyy kk:mm")
                              .format(state.actualSession!.startTime);

                          editedProducts = state.actualSession!.savedProducts
                              .where((element) => element.stock != 0)
                              .length;

                          products = state.actualSession!.savedProducts.length;

                          if (products == 0) {
                            process = 0;
                          } else {
                            process = (editedProducts / products * 100).round();
                          }
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Czas rozpoczęcia:",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date ?? "Brak aktywnej sesji",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Zeskanowane produkty:",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (editedProducts != null && products != null)
                                  ? "$editedProducts z $products rodzajów"
                                  : "Brak aktywnej sesji",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Proces księgowania:",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              process != null
                                  ? "$process%"
                                  : "Brak aktywnej sesji",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.manage_history_rounded),
                    title: const Text("Historia sesji"),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/sessions_history");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_rounded),
                    title: const Text("Ustawienia"),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/settings");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text("Informacje"),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/info");
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                if (state is SessionLoaded && state.actualSession != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<SessionCubit>().finishSession();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.save_alt_rounded),
                        label: const Text("Zakończ sesję"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFF4444)),
                        ),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //TODO powinno przekierowywac do /session_history gdzie można wybrac poprzednią sesje lub stworzyć nową
                        context.read<SessionCubit>().createNewSession();
                        context.read<ProductListCubit>().getProductList();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text("Otwórz sesję"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xEEA4C422)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
