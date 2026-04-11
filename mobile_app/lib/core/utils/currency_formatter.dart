import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String symbol) {
    final formatter = NumberFormat.currency(
      locale: symbol == 'IDR' ? 'id_ID' : 'en_US',
      symbol: symbol == 'IDR' ? 'Rp ' : symbol == 'USD' ? '\$ ' : '€ ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
