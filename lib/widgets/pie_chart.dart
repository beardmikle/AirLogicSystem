import 'dart:math' as math;
import 'package:flutter/material.dart';

class SimplePieChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color>? colors;
  final double size;
  final String? title;
  final bool isResponsive;

  const SimplePieChart({
    super.key,
    required this.data,
    this.colors,
    this.size = 200,
    this.title,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final values = data.values.toList();
    final total = values.fold<double>(0, (a, b) => a + b);
    final colorPalette = colors ?? _defaultColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивный размер диаграммы
        double chartSize = size;
        if (isResponsive) {
          if (constraints.maxWidth < 400) {
            chartSize = 150;
          } else if (constraints.maxWidth < 600) {
            chartSize = 180;
          } else if (constraints.maxWidth < 800) {
            chartSize = 200;
          } else {
            chartSize = size;
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: constraints.maxWidth < 600 ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            Container(
              width: chartSize,
              height: chartSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(chartSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _PiePainter(
                  data: data,
                  total: total == 0 ? 1 : total,
                  colors: colorPalette,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _Legend(
              data: data,
              colors: colorPalette,
              isResponsive: isResponsive,
            ),
          ],
        );
      },
    );
  }

  List<Color> get _defaultColors => const [
        Color(0xFF1976D2),
        Color(0xFF26A69A),
        Color(0xFF42A5F5),
        Color(0xFF7E57C2),
        Color(0xFFFFA726),
        Color(0xFF66BB6A),
        Color(0xFFEF5350),
        Color(0xFF29B6F6),
        Color(0xFFAB47BC),
        Color(0xFFFF7043),
      ];
}

class _PiePainter extends CustomPainter {
  final Map<String, double> data;
  final double total;
  final List<Color> colors;

  _PiePainter({
    required this.data,
    required this.total,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = math.min(size.width, size.height) / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    double startAngle = -math.pi / 2;
    int colorIndex = 0;

    for (final entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;
      paint.color = colors[colorIndex % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
      colorIndex++;
    }

    // Вырезаем серединку для donut-эффекта
    final holePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius * 0.55, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Legend extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;
  final bool isResponsive;

  const _Legend({
    required this.data,
    required this.colors,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивная легенда
        if (constraints.maxWidth < 300) {
          // Очень узкие экраны - вертикальная легенда
          return Column(
            children: [
              for (int i = 0; i < entries.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _LegendItem(
                    color: colors[i % colors.length],
                    label: entries[i].key,
                    isResponsive: isResponsive,
                  ),
                ),
            ],
          );
        } else {
          // Широкие экраны - горизонтальная легенда
          return Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < entries.length; i++)
                _LegendItem(
                  color: colors[i % colors.length],
                  label: entries[i].key,
                  isResponsive: isResponsive,
                ),
            ],
          );
        }
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isResponsive;

  const _LegendItem({
    required this.color,
    required this.label,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивный размер элементов легенды
        double iconSize = 12;
        double fontSize = 12;
        double maxWidth = 200;
        
        if (isResponsive) {
          if (constraints.maxWidth < 400) {
            iconSize = 10;
            fontSize = 10;
            maxWidth = 150;
          } else if (constraints.maxWidth < 600) {
            iconSize = 12;
            fontSize = 11;
            maxWidth = 180;
          } else {
            iconSize = 12;
            fontSize = 12;
            maxWidth = 200;
          }
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
