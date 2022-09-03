import 'package:scanner_app/models/product_model.dart';

int firstFlaggedComparison(Product a, Product b) {
  if (a.isFlagged == true && b.isFlagged == false) {
    return -1;
  } else if (a.isFlagged == false && b.isFlagged == true) {
    return 1;
  } else {
    return 0;
  }
}
