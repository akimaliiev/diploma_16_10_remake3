import 'package:diploma_16_10/components/my_button.dart';
import 'package:diploma_16_10/components/plus_button.dart';
import 'package:flutter/material.dart';

class LoanCalculatorPage extends StatefulWidget {
  const LoanCalculatorPage({super.key});

  @override
  State<LoanCalculatorPage> createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final TextEditingController _pp = TextEditingController();
  final TextEditingController _dp = TextEditingController();
  final TextEditingController _ir = TextEditingController();
  final TextEditingController _t = TextEditingController();
  double downPayment = 0;

  void _showDialog(BuildContext context) {
    if (_pp.text.isEmpty ||
        _dp.text.isEmpty ||
        _ir.text.isEmpty ||
        _t.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double principal = double.parse(_pp.text.replaceAll(',', '')) -
        double.parse(_dp.text.replaceAll(',', ''));
    double monthly = principal / int.parse(_t.text);
    double interestRate = double.parse(_ir.text) / 100;
    double interest = principal * interestRate;
    double totalInterest = interest * int.parse(_t.text);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Loan Amount"),
                  trailing: Text('${_pp.text} KZT'),
                ),
                ListTile(
                  title: const Text("Down Payment"),
                  trailing: Text('${_dp.text} KZT'),
                ),
                ListTile(
                  title: const Text("Principal"),
                  trailing: Text('$principal KZT'),
                ),
                ListTile(
                  title: const Text("Interest Rate"),
                  trailing: Text('${_ir.text}%'),
                ),
                ListTile(
                  title: const Text("Loan Term"),
                  trailing: Text('${_t.text} months'),
                ),
                ListTile(
                  title: const Text("Monthly Payment"),
                  trailing: Text('$monthly KZT'),
                ),
                ListTile(
                  title: const Text("Total Interest"),
                  trailing: Text('$totalInterest KZT'),
                ),
                ListTile(
                  title: const Text("Total Payment"),
                  trailing: Text('${monthly + interest} KZT'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          'Loan Calculator',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        centerTitle: true,
        
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 15,),
          TextField(
            cursorColor: Colors.black,
            controller: _pp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Loan Amount',
              suffixText: 'KZT',
            ),
          ),
          const SizedBox(height: 8),
          const Text("Down Payment"),
          Slider(
            value: downPayment,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${downPayment.toStringAsFixed(0)}%',
            onChanged: (double val) {
              setState(() {
                downPayment = val;
                int pp = int.tryParse(_pp.text.replaceAll(',', '')) ?? 0;
                _dp.text = ((pp * downPayment) / 100).toStringAsFixed(0);
              });
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _dp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Down Payment',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ir,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Interest Rate',
              suffixIcon: Icon(Icons.percent_outlined),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _t,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Loan Term in months',
              suffixIcon: Icon(Icons.calendar_month_outlined),
            ),
          ),
          const SizedBox(height: 270),
          MyButton(
            onTap: () => _showDialog(context),
            text: 'Calculate',
          ),
        ]),
      ),
    );
  }
}
