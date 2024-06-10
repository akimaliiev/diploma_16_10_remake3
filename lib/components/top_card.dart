import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  const TopCard({required this.balance,required this.income, required this.expense, super.key});
  final String balance;
  final String income;
  final String expense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text('B A L A N C E',
                style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 16)),
              Text( 'KZT ' + balance,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 35),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Theme.of(context).colorScheme.onPrimary,),
                      Column(
                        children: [
                          Text('Income', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                          Text('KZT '+income,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold
                          ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_downward, color: Theme.of(context).colorScheme.onPrimary,),
                      Column(
                        children: [
                          Text('Expense', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                          Text('KZT '+expense,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold
                          ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 15,
              spreadRadius: 1.0,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15,
              spreadRadius: 1
            ),
          ]
        ),
      ),
    );
  }
}