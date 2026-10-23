import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model: the mortgage data shared by both screens through Provider.
// ChangeNotifier lets the screens rebuild when the data changes.
class Mortgage extends ChangeNotifier {
  double _amount = 100000.0;
  int _years = 30;
  double _rate = 0.035;

  double get amount => _amount;
  int get years => _years;
  double get rate => _rate;

  // Load the last saved inputs (or keep the defaults on first launch)
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _amount = prefs.getDouble('amount') ?? _amount;
    _years = prefs.getInt('years') ?? _years;
    _rate = prefs.getDouble('rate') ?? _rate;
    notifyListeners();
  }

  // Called by the Done button: update the data, save it, and notify listeners
  Future<void> update(int newYears, double newAmount, double newRate) async {
    if (newYears >= 0) _years = newYears;
    if (newAmount >= 0) _amount = newAmount;
    if (newRate >= 0) _rate = newRate;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('years', _years);
    await prefs.setDouble('amount', _amount);
    await prefs.setDouble('rate', _rate);
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