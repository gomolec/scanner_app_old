import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/session_cubit/session_cubit.dart';

import '../../cubit/product_list_cubit/product_list_cubit.dart';
import '../../models/session_model.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 1), () => showLastSessionDialog(context));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Image(
            height: kToolbarHeight * 0.8,
            image: AssetImage('assets/logo.png'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: MediaQuery.of(context).size.height * 0.35,
              image: const AssetImage('assets/welcome_illustration.png'),
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 8.0),
            Text(
              "ZACZYNAMY",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Wybierz wcześniej odpowiednio przygotowany plik z listą artykułów za pomocą przycisku poniżej. Następnie możesz przejść do skanowania artykułów i uzupełniania zapasów. Życzymy miłej pracy!",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SessionCubit>().createNewSession();
                context.read<ProductListCubit>().getProductList();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text("Wybierz"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xEEA4C422)),
              ),
            ),
            const SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }
}

//TODO zapobiec ponownemu wyswietlaniu sie dialogu
//sprobowac wymienic nadrzędny widget na stateful
//i uruchomic funkcje z "widget binging???"
void showLastSessionDialog(BuildContext context) {
  if (context.read<SessionCubit>().state is SessionLoaded &&
      context.read<SessionCubit>().sessionsHistory.isNotEmpty) {
    Session lastSession = context.read<SessionCubit>().sessionsHistory.last;
    if (lastSession.endTime == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Wykryto niezakończoną sesję"),
          content: Text(
              "Czy chcesz przywrócić niezakończoną sesję z dnia ${lastSession.startTime.toString()}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(const Color(0xEEA4C422)),
              ),
              child: const Text("Nie"),
            ),
            TextButton(
              onPressed: () {
                context.read<SessionCubit>().restoreSession(
                      sessionIndex: context
                          .read<SessionCubit>()
                          .sessionsHistory
                          .indexOf(lastSession),
                    );
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(const Color(0xEEA4C422)),
              ),
              child: const Text("Tak"),
            ),
          ],
        ),
      );
    }
  }
}
