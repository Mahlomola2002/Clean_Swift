import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import the intl package

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  Future<void> _fetchAppointments() async {
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      transactions = [
        {
          "transactionID": "TXN001",
          "customerName": "John Doe333",
          "startDate": "2024-12-01",
          "endDate": "2024-12-01",
          "hoursPerDay": 2,
          "pay": 800,
          "status": "Completed",
          "service": "Deep Cleaning",
        },
        {
          "transactionID": "TXN002",
          "customerName": "John Doe",
          "startDate": "2024-12-02",
          "endDate": "2024-12-02",
          "hoursPerDay": 1.5,
          "pay": 82,
          "status": "Pending",
          "service": "Deep Cleaning",
        },
        {
          "transactionID": "TXN003",
          "customerName": "Love Jon",
          "startDate": "2024-12-03",
          "endDate": "2024-12-03",
          "hoursPerDay": 2,
          "pay": 100,
          "status": "Completed",
          "service": "Deep Cleaning",
        },
        {
          "transactionID": "TXN004",
          "customerName": "Pule John",
          "startDate": "2024-12-04",
          "endDate": "2024-12-04",
          "hoursPerDay": 1,
          "pay": 100,
          "status": "Incomplete",
          "service": "Clean Windows",
        },
      ];

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointments(); // Fetch datas when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 77, 64),
        title: const Text(
          "Transactions",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text(
                      "Earnings",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildEarningsGraph(transactions),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: buildTransactionsTable(transactions),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEarningsGraph(List<Map<String, dynamic>> transactions) {
    final earningsData = _prepareEarningsData(
        transactions); //return the list of past 7 days transactions

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: BarChart(
        BarChartData(
          barGroups: earningsData.map((data) {
            return BarChartGroupData(
              x: data['index'],
              barRods: [
                BarChartRodData(
                  toY: data['earnings'].toDouble(),
                  color: Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: const Text("Earnings"),
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text("Date"),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    earningsData.firstWhere(
                        (data) => data['index'] == value.toInt())['date'],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareEarningsData(
      List<Map<String, dynamic>> transactions) {
    final now = DateTime.now();

    final last7Days = List.generate(7, (i) {
      final date = now.subtract(Duration(days: i));
      return {
        'date': DateFormat('MM/dd').format(date),
        'earnings': 0.0,
      };
    }).reversed.toList();

    for (var transaction in transactions) {
      final startDate = DateTime.parse(transaction['startDate']);
      for (var day in last7Days) {
        if (DateFormat('MM/dd').format(startDate) == day['date']) {
          // Safely add the pay value, defaulting to 0 if null
          day['earnings'] = (day['earnings'] as double) +
              (transaction['pay'] as double? ?? 0.0);
        }
      }
    }

    for (int i = 0; i < last7Days.length; i++) {
      last7Days[i]['index'] = i;
    }

    return last7Days;
  }

  Widget buildTransactionsTable(List<Map<String, dynamic>> transactions) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 1000, // Set a minimum width for the table
        ),
        child: DataTable(
          columnSpacing: 16,
          columns: const [
            DataColumn(label: Text('Transaction ID')),
            DataColumn(label: Text('Client Name')),
            DataColumn(label: Text('Start Date')),
            DataColumn(label: Text('End Date')),
            DataColumn(label: Text('Hours/Day')),
            DataColumn(label: Text('Pay')),
            DataColumn(label: Text('Status')),
          ],
          rows: transactions.map((transaction) {
            Color statusColor = switch (transaction['status']) {
              'Pending' => Colors.yellow,
              'Completed' => Colors.green,
              'Incomplete' => Colors.red,
              _ => Colors.grey
            };

            return DataRow(cells: [
              DataCell(Text(transaction['transactionID'])),
              DataCell(Text(transaction['customerName'])),
              DataCell(Text(transaction['startDate'])),
              DataCell(Text(transaction['endDate'])),
              DataCell(Text(transaction['hoursPerDay'].toString())),
              DataCell(Text(transaction['pay'].toString())),
              DataCell(
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction['status'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
