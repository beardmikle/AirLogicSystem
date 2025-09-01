import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/device_db_service.dart';
import '../../services/session_service.dart';

// Единый фоновый цвет страницы и подложек
const kBg = Color(0xFFF4F7FE);

class Device {
  final String id;
  final String name;
  final String brand;
  final String type;
  final String serialNumber;
  final DateTime? verificationDate;
  final DateTime? commissioningDate;
  final bool isOn;
  final int emergencyStatus;
  final double? pinX; // relative to image center (pixels)
  final double? pinY; // relative to image center (pixels)

  Device({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.serialNumber,
    this.verificationDate,
    this.commissioningDate,
    this.isOn = false,ыефе
    this.emergencyStatus = 0,
    this.pinX,
    this.pinY,
  });

  Device copyWith({
    String? id,
    String? name,
    String? brand,
    String? type,
    String? serialNumber,
    DateTime? verificationDate,
    DateTime? commissioningDate,
    bool? isOn,
    int? emergencyStatus,
    double? pinX,
    double? pinY,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      serialNumber: serialNumber ?? this.serialNumber,
      verificationDate: verificationDate ?? this.verificationDate,
      commissioningDate: commissioningDate ?? this.commissioningDate,
      isOn: isOn ?? this.isOn,
      emergencyStatus: emergencyStatus ?? this.emergencyStatus,
      pinX: pinX ?? this.pinX,
      pinY: pinY ?? this.pinY,
    );
  }
}

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final List<Device> _devices = [];
  String? _selectedDeviceId;

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _typeController = TextEditingController();
  final _serialNumberController = TextEditingController();
  DateTime? _verificationDate;
  DateTime? _commissioningDate;
  bool _isOn = false;
  int _emergencyStatus = 0;

  String _sortColumn = 'name';
  bool _sortAscending = true;

  // 60 / 40 по умолчанию
  double _splitRatio = 0.7;

  final String _imagePath = 'assets/maps/map1.png';

  // ==== Карта: масштаб и панорамирование
  final TransformationController _mapController = TransformationController();
  final double _minScale = 0.5;
  final double _maxScale = 3.0;
  bool _placingPin = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _typeController.dispose();
    _serialNumberController.dispose();
    _mapController.dispose();
    super.dispose();
  }


  Future<void> _loadDevices() async {
    final username = SessionService.getCurrentUsername() ?? 'guest';
    var stored = DeviceDbService.list(username);
    // If DB is empty, seed 6 demo devices with pins and different statuses
    if (stored.isEmpty) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final samples = <StoredDevice>[
        StoredDevice(
          id: '${now}_1',
          name: 'Датчик CO — Север',
          brand: 'Acme',
          type: 'Gas CO',
          serialNumber: 'CO-A1-0001',
          verificationDate: DateTime.now().subtract(const Duration(days: 120)),
          commissioningDate: DateTime.now().subtract(const Duration(days: 365)),
          isOn: true,
          emergencyStatus: 0,
          pinX: -180,
          pinY: -120,
        ),
        StoredDevice(
          id: '${now}_2',
          name: 'Датчик NO2 — Восток',
          brand: 'Contoso',
          type: 'Gas NO2',
          serialNumber: 'NO2-B2-0002',
          verificationDate: DateTime.now().subtract(const Duration(days: 300)),
          commissioningDate: DateTime.now().subtract(const Duration(days: 500)),
          isOn: false,
          emergencyStatus: 1,
          pinX: 160,
          pinY: -90,
        ),
        StoredDevice(
          id: '${now}_3',
          name: 'Термодатчик — Центр',
          brand: 'Globex',
          type: 'Temperature',
          serialNumber: 'TMP-C3-0003',
          verificationDate: DateTime.now().subtract(const Duration(days: 30)),
          commissioningDate: DateTime.now().subtract(const Duration(days: 60)),
          isOn: true,
          emergencyStatus: 0,
          pinX: 0,
          pinY: 0,
        ),
        StoredDevice(
          id: '${now}_4',
          name: 'Давление — Юг',
          brand: 'Initech',
          type: 'Pressure',
          serialNumber: 'PRS-D4-0004',
          verificationDate: DateTime.now().subtract(const Duration(days: 200)),
          commissioningDate: DateTime.now().subtract(const Duration(days: 700)),
          isOn: true,
          emergencyStatus: 1,
          pinX: -140,
          pinY: 130,
        ),
        StoredDevice(
          id: '${now}_5',
          name: 'Влажность — Запад',
          brand: 'Umbrella',
          type: 'Humidity',
          serialNumber: 'HMD-E5-0005',
          verificationDate: DateTime.now().subtract(const Duration(days: 90)),
          commissioningDate: DateTime.now().subtract(const Duration(days: 400)),
          isOn: false,
          emergencyStatus: 0,
          pinX: -260,
          pinY: 20,
        ),
        StoredDevice(
          id: '${now}_6',
          name: 'Метан — Юго-Восток',
          brand: 'Soylent',
          type: 'Gas CH4',
          serialNumber: 'CH4-F6-0006',
          verificationDate: DateTime.now().subtract(const Duration(days: 15)),
          commissioningDate: DateTime.now().subtract(const Duration(days: 45)),
          isOn: true,
          emergencyStatus: 0,
          pinX: 220,
          pinY: 160,
        ),
      ];
      for (final s in samples) {
        await DeviceDbService.add(username, s);
      }
      stored = DeviceDbService.list(username);
    }
    setState(() {
      _devices
        ..clear()
        ..addAll(stored.map((e) => Device(
          id: e.id,
          name: e.name,
          brand: e.brand,
          type: e.type,
          serialNumber: e.serialNumber,
          verificationDate: e.verificationDate,
          commissioningDate: e.commissioningDate,
          isOn: e.isOn,
          emergencyStatus: e.emergencyStatus,
          pinX: e.pinX,
          pinY: e.pinY,
        )));
    });
  }

  // Виджет круглого индикатора
  Widget _buildCircularIndicator({
    required bool isActive,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Color(0xfff01b574) : Colors.red,
            boxShadow: [
              BoxShadow(
                color: (isActive ? Color(0xfff01b574) : Colors.red).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.circle, size: 16, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg, // фон всей страницы
      body: Column(
        children: [
          _buildControlPanel(),
          Divider(height: 1, color: Colors.black.withOpacity(0.06)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ====== Таблица (левая часть) 60%
                    Expanded(
                      flex: (_splitRatio * 100).toInt(),
                      child: _devices.isEmpty
                          ? _buildEmptyState()
                          : _buildDevicesTable(constraints),
                    ),

                    // ====== Разделитель (resize)
                    GestureDetector(
                      onHorizontalDragUpdate: (d) {
                        setState(() {
                          _splitRatio += d.delta.dx / constraints.maxWidth;
                          _splitRatio = _splitRatio.clamp(0.3, 0.7);
                        });
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.resizeLeftRight,
                        child: Container(
                          width: 8,
                          color: Colors.black.withOpacity(0.06),
                          child: Center(
                            child: Container(width: 2, color: Colors.black.withOpacity(0.15)),
                          ),
                        ),
                      ),
                    ),

                    // ====== Карта (правая часть) 40%
                    Expanded(
                      flex: ((1 - _splitRatio) * 100).toInt(),
                      child: _buildImagePane(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ====== Control Panel
  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kBg, // подложка панели
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _showAddDeviceDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xfff01b574),  
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+', style: TextStyle(fontSize: 10, 
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text('Добавить', style: TextStyle(fontSize: 10, 
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFF4F7FE), // чип статистики — контрастная карточка F4F7FE Color(0xFF4318FF)
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF4318FF).withOpacity(0.1)),
            ),
            child: Text(
              'Всего устройств: ${_devices.length}',
              style: TextStyle(fontSize: 10, color: Color(0xFF4318FF), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ====== Empty State
  Widget _buildEmptyState() {
    return Container(
      color: kBg,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📱', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('Нет добавленных устройств',
                style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w500)),
            SizedBox(height: 12),
            Text('Нажмите "Добавить" для создания нового устройства',
                style: TextStyle(color: Colors.red, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ====== Devices Table (Adaptive)
  Widget _buildDevicesTable(BoxConstraints constraints) {
    final sorted = _getSortedDevices();
    final columnWidth = constraints.maxWidth / 9;

    return Container(
      color: kBg, // подложка секции с таблицей
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _getSortColumnIndex(),
                  sortAscending: _sortAscending,
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateProperty.all(Color(0xFFE9EDF7)),  
                  headingRowHeight: 56,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 72,
                  columnSpacing: 15,
                  horizontalMargin: 20,
                  columns: [
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Название', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('name', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Марка', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('brand', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Тип', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('type', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Серийный номер', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('serialNumber', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Коорд. булавки', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Статус', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('isOn', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Авария', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('emergencyStatus', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Поверка', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('verificationDate', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Ввод', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('commissioningDate', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Действия', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFA3AED0)), overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  rows: sorted.map((d) {
                    final selected = _selectedDeviceId == d.id;
                    return DataRow(
                      selected: selected,
                      color: WidgetStateProperty.resolveWith<Color?>(
                        (states) => states.contains(WidgetState.selected) ? Colors.blue.shade100 : null,
                      ),
                      onSelectChanged: (val) => setState(() => _selectedDeviceId = val == true ? d.id : null),
                      cells: [
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.name, style: const TextStyle( color: Color(0xFF2B3674)),overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.brand, style: const TextStyle( color: Color(0xFF2B3674)),overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.type, style: const TextStyle( color: Color(0xFF2B3674)),overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.serialNumber, style: const TextStyle( color: Color(0xFF2B3674)),overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: columnWidth),
                          child: Text(
                            (d.pinX != null && d.pinY != null)
                                ? '(${d.pinX!.toStringAsFixed(0)}, ${d.pinY!.toStringAsFixed(0)})'
                                : '—',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        DataCell(
                          Center(
                            child: _buildCircularIndicator(
                              isActive: d.isOn,
                              onTap: () => _togglePower(d),
                              tooltip: d.isOn ? 'Включено (нажмите для выключения)' : 'Выключено (нажмите для включения)',
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: _buildCircularIndicator(
                              isActive: d.emergencyStatus == 0, // зелёный для нормы (0), красный для аварии (1)
                              onTap: () => _toggleEmergency(d),
                              tooltip: d.emergencyStatus == 0 ? 'Норма (нажмите для аварии)' : 'Авария (нажмите для нормы)',
                            ),
                          ),
                        ),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.verificationDate?.toLocal().toString().split(' ').first ?? 'Не указана', style: const TextStyle( color: Color(0xFF2B3674)),overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.commissioningDate?.toLocal().toString().split(' ').first ?? 'Не указана',style: const TextStyle( color: Color(0xFF2B3674)), overflow: TextOverflow.ellipsis))),
                        DataCell(Row(
                          children: [
                            IconButton(tooltip: 'Редактировать', onPressed: () => _showEditDeviceDialog(d), icon: const Text('✏️')),
                            IconButton(tooltip: 'Удалить', onPressed: () => _showDeleteConfirmation(d), icon: const Text('🗑️')),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====== Панель карты (панорамирование + зум)
  Widget _buildImagePane() {
    return Container(
      color: kBg, // подложка правой панели
      child: Column(
        children: [
          // Header (кнопки управления)
          Container(
            padding: const EdgeInsets.all(12),
            color: kBg, // подложка хедера карты
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconBtn('🔍+', () => _zoom(1.25), 'Увеличить'),
                const SizedBox(width: 8),
                _iconBtn('🔍-', () => _zoom(1 / 1.25), 'Уменьшить'),
                const SizedBox(width: 8),
                _iconBtn('📏', _resetView, '1:1'),
                const SizedBox(width: 8),
                _iconBtn(_placingPin ? '📍✓' : '📍', _togglePlacePinMode, _placingPin ? 'Режим установки булавки (вкл.)' : 'Установить булавку'),
                const SizedBox(width: 16),
                _iconBtn('⬅️', () => _pan(const Offset(80, 0)), 'Сместить влево'),
                const SizedBox(width: 4),
                _iconBtn('➡️', () => _pan(const Offset(-80, 0)), 'Сместить вправо'),
                const SizedBox(width: 4),
                _iconBtn('⬆️', () => _pan(const Offset(0, 80)), 'Сместить вверх'),
                const SizedBox(width: 4),
                _iconBtn('⬇️', () => _pan(const Offset(0, -80)), 'Сместить вниз'),
              ],
            ),
          ),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: kBg, // подложка статуса
            // child: Row(
            //   children: [
            //     const Text('Статус: ', style: TextStyle(fontWeight: FontWeight.w500)),
            //     Expanded(
            //       child: Text(
            //         _imageStatus,
            //         style: const TextStyle(color: Colors.black87, fontSize: 12),
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
          ),

          // Viewer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white, // карточка-вьювер — оставил белой для контраста
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      return InteractiveViewer(
                        transformationController: _mapController,
                        minScale: _minScale,
                        maxScale: _maxScale,
                        boundaryMargin: const EdgeInsets.all(120),
                        panEnabled: true,
                        scaleEnabled: true,
                        child: LayoutBuilder(
                          builder: (context, inner) {
                            final width = inner.maxWidth;
                            final height = inner.maxHeight;
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) async {
                                if (!_placingPin) return;
                                final local = details.localPosition;
                                final relX = local.dx - width / 2;
                                final relY = local.dy - height / 2;
                                final selectedId = await _promptSelectDeviceId();
                                if (selectedId == null) return;
                                await _savePinForDevice(selectedId, relX, relY);
                                setState(() {
                                  final idx = _devices.indexWhere((d) => d.id == selectedId);
                                  if (idx != -1) {
                                    _devices[idx] = _devices[idx].copyWith(pinX: relX, pinY: relY);
                                  }
                                  _placingPin = false;
                                });
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Булавка установлена и сохранена')),
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  Image.asset(
                                    _imagePath,
                                    fit: BoxFit.cover,
                                    width: width,
                                    height: height,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Ошибка загрузки изображения',
                                          style: TextStyle(color: Colors.red.shade800),
                                        ),
                                      );
                                    },
                                  ),
                                  ..._buildPins(width, height),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Footer path (debug)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            color: kBg, // подложка футера карты
            child: SelectableText(
              _imagePath,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ==== Управление картой ====

  void _resetView() {
    _mapController.value = Matrix4.identity();
  }

  void _zoom(double factor) {
    // масштабируем вокруг центра виджета
    final curr = _mapController.value;
    final currScale = _extractScale(curr);
    final nextScale = (currScale * factor).clamp(_minScale, _maxScale);

    // относительный множитель
    final relative = nextScale / currScale;

    // центр (фокус) — середина виджета
    final focal = Offset.zero;
    final m = _mapController.value.clone()
      ..translate(focal.dx, focal.dy)
      ..scale(relative)
      ..translate(-focal.dx, -focal.dy);

    _mapController.value = m;
  }

  void _pan(Offset delta) {
    // переносим матрицу
    final m = _mapController.value.clone()..translate(delta.dx, delta.dy);
    _mapController.value = m;
  }

  double _extractScale(Matrix4 m) {
    // длина первого столбца (scaleX)
    final sx = math.sqrt(m.entry(0, 0) * m.entry(0, 0) + m.entry(1, 0) * m.entry(1, 0) + m.entry(2, 0) * m.entry(2, 0));
    return sx;
  }

  Widget _iconBtn(String text, VoidCallback onTap, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white, // кнопка как маленькая карточка
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
            ),
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );
  }

  void _togglePlacePinMode() {
    setState(() {
      _placingPin = !_placingPin;
    });
    if (_placingPin && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нажмите на карту, чтобы установить булавку')),
      );
    }
  }

  List<Widget> _buildPins(double width, double height) {
    final centerX = width / 2;
    final centerY = height / 2;
    return _devices.where((d) => d.pinX != null && d.pinY != null).map((d) {
      final dx = centerX + (d.pinX ?? 0);
      final dy = centerY + (d.pinY ?? 0);
      return Positioned(
        left: dx - 8,
        top: dy - 24,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3)],
              ),
              child: Text(
                d.name,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.location_on, color: Colors.red, size: 20),
          ],
        ),
      );
    }).toList();
  }

  Future<String?> _promptSelectDeviceId() async {
    final username = SessionService.getCurrentUsername() ?? 'guest';
    final items = DeviceDbService.list(username);
    if (items.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('В БД нет устройств для привязки')),
        );
      }
      return null;
    }
    String? selected = items.first.id;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите устройство для булавки'),
          content: StatefulBuilder(
            builder: (context, setS) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selected,
                items: [
                  for (final d in items)
                    DropdownMenuItem(
                      value: d.id,
                      child: Text(d.name),
                    ),
                ],
                onChanged: (v) => setS(() => selected = v),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
            ElevatedButton(onPressed: () => Navigator.pop(context, selected), child: const Text('Привязать')),
          ],
        );
      },
    );
  }

  Future<void> _savePinForDevice(String deviceId, double x, double y) async {
    final username = SessionService.getCurrentUsername() ?? 'guest';
    final list = DeviceDbService.list(username);
    final idx = list.indexWhere((e) => e.id == deviceId);
    if (idx == -1) return;
    final orig = list[idx];
    final updated = StoredDevice(
      id: orig.id,
      name: orig.name,
      brand: orig.brand,
      type: orig.type,
      serialNumber: orig.serialNumber,
      verificationDate: orig.verificationDate,
      commissioningDate: orig.commissioningDate,
      isOn: orig.isOn,
      emergencyStatus: orig.emergencyStatus,
      pinX: x,
      pinY: y,
    );
    await DeviceDbService.update(username, updated);
    await _loadDevices();
  }

  // ====== CRUD Dialogs
  void _showAddDeviceDialog() {
    _clearForm();
    _showDeviceDialog('Добавить устройство', _addDevice);
  }

  void _showEditDeviceDialog(Device d) {
    _fillForm(d);
    _showDeviceDialog('Редактировать устройство', () => _editDevice(d));
  }

  void _showDeviceDialog(String title, VoidCallback onSave) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Название *', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _brandController, decoration: const InputDecoration(labelText: 'Марка', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _typeController, decoration: const InputDecoration(labelText: 'Тип', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _serialNumberController, decoration: const InputDecoration(labelText: 'Серийный номер устройства', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              _buildDateField('Дата поверки', _verificationDate, (d) => setState(() => _verificationDate = d)),
              const SizedBox(height: 16),
              _buildDateField('Дата ввода', _commissioningDate, (d) => setState(() => _commissioningDate = d)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Статус:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Switch(value: _isOn, onChanged: (v) => setState(() => _isOn = v), activeThumbColor: Colors.green),
                  Text(_isOn ? 'Вкл.' : 'Выкл.', style: TextStyle(color: _isOn ? Colors.green : Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Статус аварии:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<int>(value: 0, groupValue: _emergencyStatus, onChanged: (v) => setState(() => _emergencyStatus = v!), activeColor: Colors.green),
                      const Text('Норма'),
                      const SizedBox(width: 16),
                      Radio<int>(value: 1, groupValue: _emergencyStatus, onChanged: (v) => setState(() => _emergencyStatus = v!), activeColor: Colors.red),
                      const Text('Авария'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Название обязательно')));
                        return;
                      }
                      onSave();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, Function(DateTime?) onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: null, // чтобы не конфликтовало с кастомным labelText ниже (оставьте как было при необходимости)
          border: OutlineInputBorder(),
        ).copyWith(labelText: label, suffixIcon: Container(padding: const EdgeInsets.all(8), child: const Text('📅', style: TextStyle(fontSize: 16)))),
        child: Text(
          date?.toLocal().toString().split(' ').first ?? 'Выберите дату',
          style: TextStyle(color: date != null ? Colors.black87 : Colors.grey.shade600),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Device d) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить устройство'),
        content: Text('Вы уверены, что хотите удалить устройство "${d.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              _deleteDevice(d);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _brandController.clear();
    _typeController.clear();
    _serialNumberController.clear();
    _verificationDate = null;
    _commissioningDate = null;
    _isOn = false;
    _emergencyStatus = 0;
  }

  void _fillForm(Device d) {
    _nameController.text = d.name;
    _brandController.text = d.brand;
    _typeController.text = d.type;
    _serialNumberController.text = d.serialNumber;
    _verificationDate = d.verificationDate;
    _commissioningDate = d.commissioningDate;
    _isOn = d.isOn;
    _emergencyStatus = d.emergencyStatus;
  }

  void _addDevice() async {
    final nd = Device(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      type: _typeController.text.trim(),
      serialNumber: _serialNumberController.text.trim(),
      verificationDate: _verificationDate,
      commissioningDate: _commissioningDate,
      isOn: _isOn,
      emergencyStatus: _emergencyStatus,
      pinX: null,
      pinY: null,
    );
    setState(() {
      _devices.add(nd);
      _selectedDeviceId = nd.id;
    });
    // Persist to local DB
    try {
      final username = SessionService.getCurrentUsername() ?? 'guest';
      final stored = StoredDevice(
        id: nd.id,
        name: nd.name,
        brand: nd.brand,
        type: nd.type,
        serialNumber: nd.serialNumber,
        verificationDate: nd.verificationDate,
        commissioningDate: nd.commissioningDate,
        isOn: nd.isOn,
        emergencyStatus: nd.emergencyStatus,
      );
      await DeviceDbService.add(username, stored);
      await _loadDevices();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения устройства: $e')),
        );
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Устройство "${nd.name}" добавлено')));
    }
  }

  void _editDevice(Device old) {
    final up = Device(
      id: old.id,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      type: _typeController.text.trim(),
      serialNumber: _serialNumberController.text.trim(),
      verificationDate: _verificationDate,
      commissioningDate: _commissioningDate,
      isOn: _isOn,
      emergencyStatus: _emergencyStatus,
    );
    setState(() {
      final i = _devices.indexWhere((d) => d.id == old.id);
      if (i != -1) _devices[i] = up;
    });
    // Persist update to DB and refresh list (preserving existing pin coords if any)
    () async {
      try {
        final username = SessionService.getCurrentUsername() ?? 'guest';
        final updatedStored = StoredDevice(
          id: up.id,
          name: up.name,
          brand: up.brand,
          type: up.type,
          serialNumber: up.serialNumber,
          verificationDate: up.verificationDate,
          commissioningDate: up.commissioningDate,
          isOn: up.isOn,
          emergencyStatus: up.emergencyStatus,
          pinX: old.pinX,
          pinY: old.pinY,
        );
        await DeviceDbService.update(username, updatedStored);
        await _loadDevices();
      } catch (_) {}
    }();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Устройство "${up.name}" обновлено')));
    }
  }

  void _deleteDevice(Device d) {
    setState(() {
      _devices.removeWhere((x) => x.id == d.id);
      if (_selectedDeviceId == d.id) _selectedDeviceId = null;
    });
    // Remove from DB and refresh
    () async {
      try {
        final username = SessionService.getCurrentUsername() ?? 'guest';
        await DeviceDbService.remove(username, d.id);
        await _loadDevices();
      } catch (_) {}
    }();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Устройство "${d.name}" удалено')));
    }
  }

  void _sort(String column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _sortAscending = ascending;
    });
  }

  List<Device> _getSortedDevices() {
    final items = List<Device>.from(_devices);
    int cmp<T extends Comparable>(T a, T b) => _sortAscending ? a.compareTo(b) : b.compareTo(a);
    items.sort((a, b) {
      switch (_sortColumn) {
        case 'name':
          return cmp(a.name.toLowerCase(), b.name.toLowerCase());
        case 'brand':
          return cmp(a.brand.toLowerCase(), b.brand.toLowerCase());
        case 'type':
          return cmp(a.type.toLowerCase(), b.type.toLowerCase());
        case 'serialNumber':
          return cmp(a.serialNumber.toLowerCase(), b.serialNumber.toLowerCase());
        case 'isOn':
          return cmp(a.isOn ? 1 : 0, b.isOn ? 1 : 0);
        case 'emergencyStatus':
          return cmp(a.emergencyStatus, b.emergencyStatus);
        case 'verificationDate':
          return cmp(a.verificationDate ?? DateTime(1900), b.verificationDate ?? DateTime(1900));
        case 'commissioningDate':
          return cmp(a.commissioningDate ?? DateTime(1900), b.commissioningDate ?? DateTime(1900));
        default:
          return cmp(a.name.toLowerCase(), b.name.toLowerCase());
      }
    });
    return items;
  }

  int _getSortColumnIndex() {
    switch (_sortColumn) {
      case 'name':
        return 0;
      case 'brand':
        return 1;
      case 'type':
        return 2;
      case 'serialNumber':
        return 3;
      case 'isOn':
        return 4;
      case 'emergencyStatus':
        return 5;
      case 'verificationDate':
        return 6;
      case 'commissioningDate':
        return 7;
      default:
        return 0;
    }
  }

  void _togglePower(Device d) {
    final i = _devices.indexWhere((x) => x.id == d.id);
    if (i == -1) return;

    final updated = d.copyWith(isOn: !d.isOn);
    setState(() {
      _devices[i] = updated;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('«${updated.name}»: ${updated.isOn ? 'включено' : 'выключено'}')),
      );
    }
  }

  void _toggleEmergency(Device d) {
    final i = _devices.indexWhere((x) => x.id == d.id);
    if (i == -1) return;

    final next = d.emergencyStatus == 1 ? 0 : 1;
    final updated = d.copyWith(emergencyStatus: next);
    setState(() {
      _devices[i] = updated;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('«${updated.name}»: ${updated.emergencyStatus == 1 ? 'АВАРИЯ' : 'норма'}')),
      );
    }
  }
}


