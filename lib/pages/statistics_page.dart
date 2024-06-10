import 'package:diploma_16_10/google_sheets_api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}


class _StatisticsPageState extends State<StatisticsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          PieChartSection(),
          LineChartSection(),
        ],
      ),
    );
  }
}
class PieChartSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double totalIncome = GoogleSheetsApi.calculateIncome();
    final double totalExpense = GoogleSheetsApi.calculateExpense();
    final incomePercentage = ((totalIncome / (totalIncome+totalExpense)) * 100).toStringAsFixed(1);
    final expensePercentage = ((totalExpense / (totalIncome+totalExpense)) * 100).toStringAsFixed(1);

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Text(
            'Income vs Expense',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text('KZT '+ (totalIncome-totalExpense).toString(), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15)),
                PieChart(
                swapAnimationDuration: const Duration(milliseconds: 750),
                swapAnimationCurve: Curves.easeInOutQuint,
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: totalIncome,
                      title: '$incomePercentage%',
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: totalExpense,
                      title: '$expensePercentage%',
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      badgePositionPercentageOffset: .98,
                    ),
                  ],
                ),
              ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spots = [
      FlSpot(0, 300),
      FlSpot(1, 500),
      FlSpot(2, 200),
      FlSpot(3, 800),
      FlSpot(4, 600),
      FlSpot(5, 900),
    ];

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Text('Expenses Over Time', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(spots: spots, isCurved: true, barWidth: 5, color: Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}