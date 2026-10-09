import 'package:flutter/material.dart';
import 'mortgage.dart';
import 'modify_screen.dart';

void main() {
  runApp(const MortgageApp());
}

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mortgage Calculator',
      home: HomeScreen(),
    );
  }
}

// Screen 1 (left): shows the mortgage data
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Mortgage mortgage = Mortgage();
  bool termsAccepted = false;

  // Modify Data button: go to screen 2, then refresh when it comes back
  void openModifyScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModifyScreen(mortgage: mortgage)),
    );
    setState(() {});
  }

  // Terms and Conditions check box: confirm with an AlertDialog
  void onTermsChanged(bool? value) async {
    if (value == false) {
      setState(() => termsAccepted = false);
      return;
    }
    bool? agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const Text('Do you agree to the terms and conditions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Agree'),
          ),
        ],
      ),
    );
    setState(() => termsAccepted = agreed ?? false);
  }

  Widget row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MortgageV0')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            row('Amount', mortgage.formattedAmount()),
            row('Years', '${mortgage.years}'),
            row('Interest Rate', '${(mortgage.rate * 100).toStringAsFixed(2)}%'),
            const Divider(color: Colors.red, thickness: 2),
            row('Monthly Payment', mortgage.formattedMonthlyPayment()),
            row('Total Payment', mortgage.formattedTotalPayment()),
            CheckboxListTile(
              title: const Text('Terms and Conditions'),
              value: termsAccepted,
              onChanged: onTermsChanged,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: openModifyScreen,
                child: const Text('MODIFY DATA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
