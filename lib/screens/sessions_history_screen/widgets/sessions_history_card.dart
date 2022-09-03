import 'package:flutter/material.dart';

//TODO ulepszyć pod wzgledem wizualnym
//dodać procentowy postęp

class SessionsHistoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? trailingColor;
  final void Function()? finishButtonFunction;
  final void Function()? restoreButtonFunction;
  final void Function()? onTap;
  const SessionsHistoryCard({
    Key? key,
    this.title = '',
    this.subtitle = '',
    this.trailingColor,
    this.finishButtonFunction,
    this.restoreButtonFunction,
    this.onTap,
  }) : super(key: key);

  factory SessionsHistoryCard.actual({
    final String title = '',
    final String subtitle = '',
    final void Function()? finishButtonFunction,
    final void Function()? onTap,
  }) {
    return SessionsHistoryCard(
      title: title,
      subtitle: subtitle,
      trailingColor: const Color(0xFFA4C422),
      finishButtonFunction: finishButtonFunction,
      onTap: onTap,
    );
  }

  factory SessionsHistoryCard.saved({
    final String title = '',
    final String subtitle = '',
    final bool isfinished = false,
    final void Function()? restoreButtonFunction,
    final void Function()? onTap,
  }) {
    return SessionsHistoryCard(
      title: title,
      subtitle: subtitle,
      restoreButtonFunction: restoreButtonFunction,
      trailingColor: isfinished ? Colors.grey[500] : Colors.yellow[700],
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        shape: trailingColor != null
            ? Border(
                right: BorderSide(
                  color: trailingColor!,
                  width: 16,
                ),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(
                subtitle,
              ),
            ),
            finishButtonFunction != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: TextButton(
                      onPressed: finishButtonFunction,
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(const Color(0xFFFF4444)),
                      ),
                      child: const Text("Zakończ"),
                    ),
                  )
                : const SizedBox(),
            restoreButtonFunction != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: TextButton(
                      onPressed: restoreButtonFunction,
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(const Color(0xFFA4C422)),
                      ),
                      child: const Text("Przywróć"),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
