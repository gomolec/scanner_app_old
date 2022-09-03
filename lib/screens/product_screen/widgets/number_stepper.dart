import 'package:flutter/material.dart';

import '../../../models/product_model.dart';

class NumberStepper extends StatefulWidget {
  const NumberStepper({
    Key? key,
    required this.setCounter,
    required this.product,
  }) : super(key: key);

  final Function(int) setCounter;
  final Product product;

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.product.stock;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0x99FF4444),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_counter > 0) _counter--;
                        widget.setCounter(_counter);
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        _counter = 0;
                        widget.setCounter(_counter);
                      });
                    },
                    child: Icon(
                      Icons.remove_rounded,
                      color: Colors.black87,
                      size: MediaQuery.of(context).size.height * 0.08,
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                  children: [
                    TextSpan(
                      text: _counter.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: (() {
                          if (_counter == widget.product.delivered) {
                            return const Color(0xFFA4C422);
                          } else if (_counter > widget.product.delivered) {
                            return Colors.yellow[700];
                          }
                          return Colors.black54;
                        }()),
                      ),
                    ),
                    const TextSpan(text: ' / '),
                    TextSpan(
                      text: widget.product.delivered.toString(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0x99A4C422),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _counter++;
                        widget.setCounter(_counter);
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        _counter = widget.product.delivered;
                        widget.setCounter(_counter);
                      });
                    },
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.black87,
                      size: MediaQuery.of(context).size.height * 0.08,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
