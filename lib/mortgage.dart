import 'dart:math';

// Model: encapsulates a mortgage calculator (Dart version of the Mortgage class)
class Mortgage {
  double _amount = 100000.0;
  int _years = 30;
  double _rate = 0.035;

  double get amount => _amount;
  int get years => _years;
  double get rate => _rate;

  set amount(double newAmount) {
    if (newAmount >= 0) _amount = newAmount;
  }

  set years(int newYears) {
    if (newYears >= 0) _years = newYears;
  }

  set rate(double newRate) {
    if (newRate >= 0) _rate = newRate;
  }

  double monthlyPayment() {
    double mRate = _rate / 12; // monthly interest rate
    double temp = pow(1 / (1 + mRate), _years * 12).toDouble();
    return _amount * mRate / (1 - temp);
  }

  double totalPayment() {
    return monthlyPayment() * _years * 12;
  }

  String formattedAmount() => money(_amount);
  String formattedMonthlyPayment() => money(monthlyPayment());
  String formattedTotalPayment() => money(totalPayment());

  // Formats a number like $#,##0.00
  static String money(double value) {
    List<String> parts = value.toStringAsFixed(2).split('.');
    String whole = parts[0].replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return '\$$whole.${parts[1]}';
  }
}
