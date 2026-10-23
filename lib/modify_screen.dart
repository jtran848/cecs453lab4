import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mortgage.dart';

// Screen 2 (right): lets the user change years, amount, and interest rate
class ModifyScreen extends StatefulWidget {
  const ModifyScreen({super.key});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  // Rates from 2% to 15% in steps of 0.25% (53 values)
  final List<double> rates = List.generate(53, (i) => 2 + i * 0.25);

  late int years;
  late int selectedRateIndex;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    // read: get the shared data from Provider (already loaded from SharedPreferences)
    final mortgage = context.read<Mortgage>();
    years = mortgage.years;
    amountController =
        TextEditingController(text: mortgage.amount.toStringAsFixed(2));
    selectedRateIndex = ((mortgage.rate * 100 - 2) / 0.25).round();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  // Done button: update the shared data (which also saves it) and go back
  void done() {
    final mortgage = context.read<Mortgage>();
    mortgage.update(
      years,
      double.tryParse(amountController.text) ?? mortgage.amount,
      rates[selectedRateIndex] / 100,
    );
    Navigator.pop(context);
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
            // Years: radio buttons
            Row(
              children: [
                const SizedBox(width: 100, child: Text('Years')),
                RadioGroup<int>(
                  groupValue: years,
                  onChanged: (value) => setState(() => years = value!),
                  child: const Row(
                    children: [
                      Radio<int>(value: 10),
                      Text('10'),
                      Radio<int>(value: 15),
                      Text('15'),
                      Radio<int>(value: 30),
                      Text('30'),
                    ],
                  ),
                ),
              ],
            ),

            // Amount: text field
            Row(
              children: [
                const SizedBox(width: 100, child: Text('Amount')),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Interest Rate: ListView from 2% to 15%
            Text(
                'Interest Rate: ${rates[selectedRateIndex].toStringAsFixed(2)}%'),
            Expanded(
              child: ListView.builder(
                itemCount: rates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${rates[index].toStringAsFixed(2)}%'),
                    selected: index == selectedRateIndex,
                    selectedTileColor: Colors.blue.shade50,
                    onTap: () => setState(() => selectedRateIndex = index),
                  );
                },
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: done,
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}