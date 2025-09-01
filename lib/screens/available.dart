import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AvailableScreen extends StatefulWidget {
  const AvailableScreen({super.key});

  @override
  State<AvailableScreen> createState() {
    return _AvailableScreenState();
  }
}

class _AvailableScreenState extends State<AvailableScreen> {
  // ===== Properties ======

  bool _isExpanded = false;

  final List<Map<String, dynamic>> periods = [
    {'label': '1 Day', 'initial': 100.0, 'spent': 20.0},
    {'label': '1 Week', 'initial': 500.0, 'spent': 600.0},
    {'label': '1 Month', 'initial': 2000.0, 'spent': 1800.0},
    {'label': '1 Year', 'initial': 24000.0, 'spent': 24000.0},
  ];

  // ===== Methods ======

  // Function for calculating sectors and icons
 List<PieChartSectionData> getSections(double initial, double spent, double circleSize) {
  double gray = spent > initial ? initial : spent;
  double red = spent > initial ? spent - initial : 0;
  double green = spent < initial ? initial - spent : 0;
  double total = gray + red + green;

  final double radius = circleSize * 0.35; // радиус секции (меньше, чем circleSize)
  final double centerRadius = circleSize * 0.25; // радиус центра

  return [
    if (gray > 0)
      PieChartSectionData(
        value: gray / total * 100,
        color: Colors.grey,
        radius: radius,
        showTitle: false,
      ),
    if (red > 0)
      PieChartSectionData(
        value: red / total * 100,
        color: Colors.red,
        radius: radius,
        showTitle: false,
      ),
    if (green > 0)
      PieChartSectionData(
        value: green / total * 100,
        color: Colors.green,
        radius: radius,
        showTitle: false,
      ),
  ];
}


  IconData getCenterIcon(double initial, double spent) {
    if (spent > initial) return Icons.thumb_down; // Красный
    if (spent < initial) return Icons.thumb_up; // Зеленый
    return Icons.balance; // Нейтральный (замените на вашу иконку)
  }

  double getRemaining(double initial, double spent) {
    return spent > initial ? 0 : initial - spent;
  }

  Widget _buildExpandedText() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Available Budget in details',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // For creating circles
  Widget _buildPeriodCircles(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = 16.0;
    final itemsPerRow = 4; // сколько кругов в ряд хотим
    final availableWidth = screenWidth - (spacing * (itemsPerRow + 1));
    final circleSize = (availableWidth / itemsPerRow) / 2;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.center,
      children: periods.map((period) {
        double initial = period['initial'];
        double spent = period['spent'];

        return GestureDetector(
          onTap: () => print('Tapped ${period['label']}'),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: circleSize,  
                    height: circleSize,
                    child: PieChart(
                      PieChartData(
                       sections: getSections(initial, spent, circleSize),
                        centerSpaceRadius: circleSize * 0.25,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  Icon(
                    getCenterIcon(initial, spent),
                    size: circleSize * 0.3,
                    color: spent > initial
                        ? Colors.red
                        : (spent < initial ? Colors.green : Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(period['label'], textAlign: TextAlign.center),
              Text(
                '${getRemaining(initial, spent)} left',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===== Lifecycle ======

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       //appBar: AppBar(title: Text('Budget App')),
      body: Column(
        children: [
          SizedBox(height: 24),
          ListTile(
            title: Text('Available Budget'),
            trailing: IconButton(
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() => _isExpanded = !_isExpanded);
                print('Expand DATA!');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildPeriodCircles(context),
          ),

          if (_isExpanded) _buildExpandedText(),
        ],
      ),
    );
  }
}
