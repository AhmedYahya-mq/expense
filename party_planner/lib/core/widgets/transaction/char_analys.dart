import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/widgets/transaction/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key, required this.total});
  final Map<String, dynamic> total;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // إضافة فئات الألوان والنصوص الخاصة بالفئات المختلفة
    final colors = widget.total.entries.map((entry) => entry.value['color']).toList();
    final texts = widget.total.entries.map((entry) => entry.value['text']).toList();
    return AspectRatio(
      aspectRatio: 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: showingSections(colors),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: List.generate(widget.total.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        children: [
                          Indicator(
                            color: colors[index],
                            text: texts[index],
                            percent:  ((widget.total.entries.elementAt(index).value as Map)['percent'] as num).toDouble(),
                            isSquare: true,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<dynamic> colors) {
    // استخدم الفئات الخاصة بكل فئة للحصول على النسب
    final percentList = widget.total.entries.map((entry) => entry.value['percent']).toList();

    // التأكد من أن القائمتين لهما نفس الطول
    final int itemCount = percentList.length < colors.length
        ? percentList.length
        : colors.length;

    return List.generate(itemCount, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: colors[i],
        value: percentList[i].toDouble() ?? 0.0,
        title: '${(percentList[i] as num?)?.toDouble().toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}
