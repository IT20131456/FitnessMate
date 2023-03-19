import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_mate/services/bmi_report_service.dart';

class BmiChart extends StatelessWidget {  

  List<BmiData> data = [
    BmiData('January', 35.3),
    BmiData('Feb', 28.5),
    BmiData('Mar', 34.2),
    BmiData('Apr', 32.6),
    BmiData('May', 60.4)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Chart"),
        centerTitle: true,       
        brightness: Brightness.dark,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'BMI Trend Over Time'),
          legend: Legend(isVisible: true,),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<BmiData, String>>[
            LineSeries<BmiData, String>(
              dataSource: data,
              xValueMapper: (BmiData bmireports, _) => bmireports.date,
              yValueMapper: (BmiData bmireport, _) => bmireport.bmivalue,
              name: 'BMI Value',
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class BmiData{

  final String date;
  final double bmivalue;

  BmiData(this.date, this.bmivalue);

}









