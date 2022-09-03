import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/session_cubit/session_cubit.dart';

import '../../models/session_model.dart';
import 'widgets/sessions_history_card.dart';

class SessionsHistoryScreen extends StatelessWidget {
  const SessionsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Historia sesji",
          style: TextStyle(color: Colors.black),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFA4C422),
            width: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) {
            if (state is SessionLoaded) {
              return Column(
                children: [
                  //TODO odzielić bardziej aktualną sesje od reszty
                  state.actualSession != null
                      ? SessionsHistoryCard.actual(
                          title: "Aktualna sesja",
                          subtitle:
                              "Utworzono ${state.actualSession!.startTime}",
                          finishButtonFunction: () {},
                        )
                      : const SizedBox(), //TODO dodac przycisk z tworzeniem nowej sesji
                  state.sessionsHistory.isNotEmpty
                      ? ListView.builder(
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.sessionsHistory.length,
                          itemBuilder: (context, index) {
                            final Session session =
                                state.sessionsHistory[index];
                            if (session.endTime == null) {
                              return SessionsHistoryCard.saved(
                                title: "Niezakończona sesja",
                                subtitle: "Utworzono ${session.startTime}",
                                isfinished: false,
                                restoreButtonFunction: () {},
                              );
                            } else {
                              return SessionsHistoryCard.saved(
                                title: "Zakończona sesja",
                                subtitle:
                                    "Utworzono ${session.startTime}\nZakończono ${session.endTime}",
                                isfinished: true,
                                restoreButtonFunction: () {},
                              );
                            }
                          },
                        )
                      : const SizedBox(), //TODO dodac tekst o pustej historii
                ],
              );
            } else {
              return const SizedBox(); //TODO dodac CircleIndicator
            }
          },
        ),
      ),
    );
  }
}
