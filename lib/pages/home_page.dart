import 'dart:async';
import 'package:diploma_16_10/components/drawer.dart';
import 'package:diploma_16_10/components/google_sheets_button.dart';
import 'package:diploma_16_10/components/loading_circle.dart';
import 'package:diploma_16_10/components/my_button.dart';
import 'package:diploma_16_10/components/plus_button.dart';
import 'package:diploma_16_10/components/top_card.dart';
import 'package:diploma_16_10/components/transactions.dart';
import 'package:diploma_16_10/google_sheets_api.dart';
import 'package:diploma_16_10/pages/loan_calculator_page.dart';
import 'package:diploma_16_10/pages/profile_page.dart';
import 'package:diploma_16_10/pages/statistics_page.dart';
import 'package:diploma_16_10/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _textcontrollerAmount = TextEditingController();
  final _textcontrollerItem = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  final Map<String, double> conversionRates = {
    'USD': 0.0023,  
    'EUR': 0.0021,
    'RUB': 0.14,
    'GBP': 0.0019,
    'CNY': 0.016
  };

  bool _isIncome = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void goToStatisticsPage() {
    Navigator.pop(context);
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => StatisticsPage()));
  }

  void goToLoanCalculatorPage() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoanCalculatorPage()));
  }

  void _newTransaction() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return AlertDialog(
            title: Text('NEW TRANSACTION'),
            content: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey, 
                child: Column(
                  children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Expense'),
                        Switch(
                          value: _isIncome,
                          onChanged: (newValue) {
                            setState(() {
                              _isIncome = newValue;
                            });
                          },
                        ),
                        Text('Income'),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'For what?',
                              border: OutlineInputBorder(),
                            ),
                            controller: _textcontrollerItem,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          validator: (text) => text == null || text.isEmpty ? 'Enter an amount' : null,
                          controller: _textcontrollerAmount,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _pickDate(context),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.grey[600],
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                 Navigator.of(context).pop();
              }
            ),
            MaterialButton(
              color: Colors.grey[600],
              child: Text('Enter', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _enterTransaction();
                  setState ((){});
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      }
    );
    });
  }
  bool timerHasStarted = false;
  void startLoading(){
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer){
      if(GoogleSheetsApi.loading == false){
        setState(() {});
        timer.cancel();
      }
    });
  }

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerItem.text,
      _textcontrollerAmount.text,
      _isIncome,
      _selectedDate  
    );
    setState(() {});
  }

  void deleteTransaction(int index)async{
    GoogleSheetsApi.delete(index);
    setState(() {
    });
  }

  Widget buildCurrencyDisplays(double balance) {
    List<Widget> currencyWidgets = [];
    final Map<String, String> currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'RUB': '₽',
      'GBP': '£',
      'CNY': '¥'
    };

    conversionRates.forEach((currency, rate) {
      double converted = balance * rate;
      String symbol = currencySymbols[currency] ?? '';
      Widget currencyWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          '${symbol}${converted.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16),
        ),
      );
      currencyWidgets.add(currencyWidget);
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: currencyWidgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    if(GoogleSheetsApi.loading == true && timerHasStarted == false){
      startLoading();
    }
    
    double balance = GoogleSheetsApi.calculateIncome() - GoogleSheetsApi.calculateExpense();

    return Scaffold(
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onLogoutTap: signUserOut,
        onStatisticsTap: goToStatisticsPage,
        onLoanCalculatorTap: goToLoanCalculatorPage,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Center(
          child: Text(
            'MControl',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 25),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          GoogleSheetsButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopCard(
              balance: balance.toString(),
              income: GoogleSheetsApi.calculateIncome().toString(),
              expense: GoogleSheetsApi.calculateExpense().toString(),
            ),
            SizedBox(height: 10),
            buildCurrencyDisplays(balance),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Expanded(
                        child: GoogleSheetsApi.loading ? const LoadingCircle() : ListView.builder(
                          itemCount: GoogleSheetsApi.currentTransactions.length,
                          itemBuilder: (context, index) {
                            int reversedIndex = GoogleSheetsApi.currentTransactions.length - 1 - index;
                            return MyTransaction(
                              transactionName: GoogleSheetsApi.currentTransactions[reversedIndex][0],
                              money: GoogleSheetsApi.currentTransactions[reversedIndex][1],
                              expenseOrIncome: GoogleSheetsApi.currentTransactions[reversedIndex][2],
                              date: DateFormat('dd-MM-yyyy').format(GoogleSheetsApi.currentTransactions[reversedIndex][3] as DateTime),
                              deleteTransaction: (p0) => deleteTransaction,
                            );
                          }
                        )
                      )
                    ]
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5), 
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }  
}
