import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formapp/app/data/models/genre_model.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:get/get.dart';

class GraphicWidget extends GetView<HomeController> {
  const GraphicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        controller.touchedIndex.value = -1;
                        return;
                      }
                      controller.touchedIndex.value =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: showingSections(controller.genres),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Genre> genres) {
    final List<Color> sectionColors = [
      Colors.red,
      Colors.blue,
    ];

    final List<String> sectionImages = [
      'assets/images/female.svg',
      'assets/images/male.svg',
    ];

    return genres.asMap().entries.map((entry) {
      final int index = entry.key;
      final Genre genre = entry.value;

      int totalGenres = genres.fold(0, (sum, genre) => sum + genre.total);
      double percentage = (genre.total / totalGenres) * 100;

      final isTouched = index == controller.touchedIndex.value;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: sectionColors[index % sectionColors.length],
        value: genre.total.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          sectionImages[index % sectionImages.length],
          size: widgetSize,
          borderColor: sectionColors[index % sectionColors.length],
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });

  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}
