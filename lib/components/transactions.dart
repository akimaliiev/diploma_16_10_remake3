import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart'; 


class MyTransaction extends StatelessWidget {
  MyTransaction({super.key, required this.transactionName, required this.money, required this.expenseOrIncome, required this.date, required this.deleteTransaction});
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final String date;
  void Function(BuildContext)? deleteTransaction;



  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(), 
        children: [
          SlidableAction(
            onPressed: deleteTransaction,
            icon: Icons.delete,
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: Theme.of(context).colorScheme.secondary,
                  // child: Slidable(
                  //   endActionPane: ActionPane(
                  //     motion: const StretchMotion(), 
                  //     children: [
                  //       SlidableAction(
                  //         onPressed: onEditPressed,
                  //         icon: Icons.settings
                  //       ),
                  //       SlidableAction(
                  //         onPressed: onDeletePressed,
                  //         icon: Icons.delete,
                  //       )
                  //     ],
                  //   ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey[500]
                              ),
                              child: Center(
                                child: Icon(Icons.attach_money_outlined,color: Colors.white,),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transactionName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                date as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              ],
                            )        
                          ],
                        ),
                        Text((expenseOrIncome=='expense' ? '- ':'+ ') + 'KZT '+ money,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: (expenseOrIncome=='expense' ? Colors.red : Colors.green)),
                        ),
                    ],
                    ),
                  )
                ),    
      ),
    );
  }
}