import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/product_list_cubit/product_list_cubit.dart';

import 'package:scanner_app/models/product_model.dart';
import 'package:scanner_app/product_image_dowloader.dart';

import 'widgets/number_stepper.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    int counter = product.stock;
    void setCounter(int number) {
      counter = number;
    }

    bool isFlagged = product.isFlagged;
    void setFlag(bool value) {
      isFlagged = value;
    }

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
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xEEA4C422),
            width: 2,
          ),
        ),
        actions: [
          FlagButton(
            isFlagged: isFlagged,
            setFlag: setFlag,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProductListCubit>().updateProduct(
                product.copyWith(
                  stock: counter,
                  isFlagged: isFlagged,
                ),
              );
          Navigator.pop(context);
        },
        tooltip: 'Save',
        backgroundColor: const Color(0xFFA4C422),
        child: const Icon(Icons.save_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            FutureBuilder(
              future: getImage(product.code),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Image(
                    height: MediaQuery.of(context).size.height * 0.4,
                    image: NetworkImage(snapshot.data.toString()),
                  );
                } else if (snapshot.hasError) {
                  return const SizedBox();
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xEEA4C422),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8),
            Text(
              product.code,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 16),
            NumberStepper(product: product, setCounter: setCounter),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.link_rounded),
              label: const Text("Artykuł na stronie internetowej"),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor:
                    MaterialStateProperty.all(const Color(0xEEA4C422)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FlagButton extends StatefulWidget {
  const FlagButton({
    Key? key,
    required this.isFlagged,
    required this.setFlag,
  }) : super(key: key);
  final bool isFlagged;
  final Function(bool) setFlag;

  @override
  State<FlagButton> createState() => _FlagButtonState();
}

class _FlagButtonState extends State<FlagButton> {
  late bool _isFlagged;
  @override
  void initState() {
    _isFlagged = widget.isFlagged;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFlagged = !_isFlagged;
          widget.setFlag(_isFlagged);
        });
      },
      tooltip: 'Flag',
      icon: const Icon(Icons.flag_rounded),
      color: _isFlagged ? const Color(0xFFFF4444) : Colors.black,
    );
  }
}
