import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// ===== Стиль / цвета =====
const kBg = Color(0xFFF4F7FE);
const kHeading = Color(0xFFA3AED0);
const kText = Color(0xFF2B3674);
const kAccent = Color(0xFF4318FF);

// Цвета метрик
const _coColor = Color(0xFF3B82F6);   // синий
const _no2Color = Color(0xFF10B981);  // зелёный
const _tempColor = Color(0xFFF59E0B); // оранжевый
const _pressColor = Color(0xFF8B5CF6); // фиолетовый

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final String _deviceId = 'DEV-${1000 + math.Random().nextInt(9000)}';

  static const int _history = 120;
  late final List<double> _co;
  late final List<double> _no2;
  late final List<double> _temp;
  late final List<double> _press;

  double _coNow = 0;
  double _no2Now = 0;
  double _tempNow = 0;
  double _pressNow = 0;
  DateTime _timestamp = DateTime.now();

  Timer? _timer;
  final _rnd = math.Random();

@override
void initState() {
  super.initState();
  
  print('MonitoringPage initState called');

  _coNow = 7 + _rnd.nextDouble() * 2;
  _no2Now = 0.025 + _rnd.nextDouble() * 0.008;
  _tempNow = 23 + _rnd.nextDouble() * 2.5;
  _pressNow = 1014 + _rnd.nextDouble() * 6;

  // Создаем списки с предварительно сгенерированной историей
  _co = _generateHistoryData(_coNow, min: 0, max: 15);
  _no2 = _generateHistoryData(_no2Now, min: 0.0, max: 0.08);
  _temp = _generateHistoryData(_tempNow, min: 10, max: 40);
  _press = _generateHistoryData(_pressNow, min: 980, max: 1040);

  // Запуск таймера через небольшую задержку для web
  Future.delayed(const Duration(milliseconds: 100), () {
    if (mounted) {
      print('Starting timer');
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        print('Timer tick at ${DateTime.now()}');
        _tick();
      });
    }
  });
}


  void _tick() {
    print('_tick called - updating values');
    
    // Шаг = ±25% от высоты шкалы для каждой метрики
    final oldCoNow = _coNow;
    _coNow = _stepByScale(_coNow, min: 0, max: 15);
    _no2Now = _stepByScale(_no2Now, min: 0.0, max: 0.08);
    _tempNow = _stepByScale(_tempNow, min: 10, max: 40);
    _pressNow = _stepByScale(_pressNow, min: 980, max: 1040);

    print('CO changed from $oldCoNow to $_coNow');

    _push(_co, _coNow);
    _push(_no2, _no2Now);
    _push(_temp, _tempNow);
    _push(_press, _pressNow);

    if (mounted) {
      print('Calling setState');
      setState(() {
        _timestamp = DateTime.now();
      });
    }
  }

  List<double> _generateHistoryData(double currentValue, {required double min, required double max}) {
    final history = <double>[];
    double value = currentValue;
    
    // Генерируем историю назад во времени
    for (int i = 0; i < _history; i++) {
      // Добавляем случайные вариации для создания реалистичной истории
      final range = max - min;
      final delta = (_rnd.nextDouble() * 2 - 1) * 0.15 * range; // ±15% от диапазона
      value += delta;
      
      // Отражение от границ
      if (value < min) value = min + (min - value);
      if (value > max) value = max - (value - max);
      value = value.clamp(min, max);
      
      history.add(value);
    }
    
    // Последнее значение должно быть близко к текущему
    history[_history - 1] = currentValue;
    
    return history;
  }

  double _stepByScale(double curr, {required double min, required double max}) {
    final range = (max - min);
    final delta = ( _rnd.nextDouble() * 2 - 1 ) * 0.25 * range; // [-25%..+25%] от диапазона
    final next = curr + delta;
    // чтобы не "липло" у краёв — если вышли за пределы, отражаем
    if (next < min) return min + (min - next);
    if (next > max) return max - (next - max);
    return next.clamp(min, max);
  }

  void _push(List<double> list, double v) {
    list.removeAt(0);
    list.add(v);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildInfoCard(),
                const SizedBox(height: 12),
                _buildLegend(),
                const SizedBox(height: 12),
                _buildChartsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EDF7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kAccent.withOpacity(0.10)),
          ),
          child: const Text(
            'Realtime',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 8,
          children: [
            _kv('Device ID', _deviceId),
            _kv('Timestamp', _ts(_timestamp)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    // Легенда с цветами и параметрами
    final items = <_LegendItem>[
      _LegendItem('CO (ppm)', _coColor),
      _LegendItem('NO₂ (ppm)', _no2Color),
      _LegendItem('Temperature (°C)', _tempColor),
      _LegendItem('Pressure (hPa)', _pressColor),
    ];
    return _Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          children: items.map((i) => _LegendDot(text: i.label, color: i.color)).toList(),
        ),
      ),
    );
  }

  Widget _buildChartsGrid() {
    return SizedBox(
      height: 800, // Фиксированная высота для grid
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
        physics: const NeverScrollableScrollPhysics(), // Отключаем скролл grid
        children: [
          _MetricCard(
            title: 'CO',
            value: _coNow,
            unit: 'ppm',
            series: _co,
            hintMin: 0,
            hintMax: 15,
            lineColor: _coColor,
          ),
          _MetricCard(
            title: 'NO₂',
            value: _no2Now,
            unit: 'ppm',
            series: _no2,
            hintMin: 0.0,
            hintMax: 0.08,
            lineColor: _no2Color,
          ),
          _MetricCard(
            title: 'Temperature',
            value: _tempNow,
            unit: '°C',
            series: _temp,
            hintMin: 10,
            hintMax: 40,
            lineColor: _tempColor,
          ),
          _MetricCard(
            title: 'Pressure',
            value: _pressNow,
            unit: 'hPa',
            series: _press,
            hintMin: 980,
            hintMax: 1040,
            lineColor: _pressColor,
          ),
        ],
      ),
    );
  }

  String _ts(DateTime dt) {
    final d = dt.toLocal();
    String two(int x) => x.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
  }

  Widget _kv(String k, String v) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$k: ',
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w600,
            color: kHeading,
          ),
        ),
        Text(
          v,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            color: kText,
          ),
        ),
      ],
    );
  }
}

// ===== Карточка метрики с цветными линией/заливкой =====
class _MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final List<double> series;
  final double hintMin;
  final double hintMax;
  final Color lineColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.series,
    required this.hintMin,
    required this.hintMax,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final decimals = unit == 'ppm'
        ? (title == 'CO' ? 2 : 3)
        : (unit == '°C' ? 1 : 0);

    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: kText,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EDF7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kAccent.withOpacity(0.10)),
                  ),
                  child: Text(
                    '${value.toStringAsFixed(decimals)} $unit',
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: kAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _LineChart(
                key: ValueKey('${title}_${series.last}_${series.hashCode}'),
                data: List.from(series), // создаем копию для избежания проблем с референсами
                hintMin: hintMin,
                hintMax: hintMax,
                lineColor: lineColor,
                fillColor: lineColor.withOpacity(0.14),
                gridColor: const Color(0xFFE9EDF7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Универсальная карточка =====
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: child,
    );
  }
}

// ===== Легенда =====
class _LegendItem {
  final String label;
  final Color color;
  _LegendItem(this.label, this.color);
}

class _LegendDot extends StatelessWidget {
  final String text;
  final Color color;
  const _LegendDot({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w600,
            color: kText,
          ),
        ),
      ],
    );
  }
}

// ===== Простой line chart на Canvas с настраиваемыми цветами =====
class _LineChart extends StatelessWidget {
  final List<double> data;
  final double hintMin;
  final double hintMax;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  const _LineChart({
    super.key,
    required this.data,
    required this.hintMin,
    required this.hintMax,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        painter: _LineChartPainter(
          data: data,
          minY: hintMin,
          maxY: hintMax,
          lineColor: lineColor,
          fillColor: fillColor,
          gridColor: gridColor,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final double minY;
  final double maxY;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  _LineChartPainter({
    required this.data,
    required this.minY,
    required this.maxY,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // фон
    final bg = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, bg);

    // сетка
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const gridLines = 4;
    for (int i = 1; i < gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (data.isEmpty) return;

    final path = Path();
    final line = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final shade = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    double toY(double v) {
      final clamped = v.clamp(minY, maxY);
      final t = (clamped - minY) / (maxY - minY + 1e-9);
      return size.height * (1 - t);
    }

    final stepX = data.length > 1 ? size.width / (data.length - 1) : size.width;
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      points.add(Offset(i * stepX, toY(data[i])));
    }

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(fillPath, shade);
    canvas.drawPath(path, line);

    // последняя точка
    final last = points.last;
    canvas.drawCircle(last, 3.5, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return data != oldDelegate.data ||
           minY != oldDelegate.minY ||
           maxY != oldDelegate.maxY ||
           lineColor != oldDelegate.lineColor ||
           fillColor != oldDelegate.fillColor ||
           gridColor != oldDelegate.gridColor;
  }
}