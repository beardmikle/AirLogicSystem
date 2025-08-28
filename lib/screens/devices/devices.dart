import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  Device({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.serialNumber,
    this.verificationDate,
    this.commissioningDate,
    this.isOn = false,
    this.emergencyStatus = 0,
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
  double _splitRatio = 0.6;

  late final String _baseUrl; // http://<host>:8000
  final String _imagePath = 'assets/maps/map1.png';

  // ==== Карта: масштаб и панорамирование
  final TransformationController _mapController = TransformationController();
  final double _minScale = 0.5;
  final double _maxScale = 3.0;
  String _imageStatus = 'Инициализация...';

  @override
  void initState() {
    super.initState();
    _baseUrl = _detectBaseUrl();
    _loadDevices();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _imageStatus = 'Карта загружена';
      });
    });
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

  String _detectBaseUrl() {
    if (kIsWeb) {
      final u = Uri.base; // http://localhost:<any port>/
      return Uri(scheme: 'http', host: u.host, port: 8000).toString();
    } else {
      // Replace with your LAN-IP for real device
      return 'http://192.168.31.187:8000';
      // Android emulator: return 'http://10.0.2.2:8000';
    }
  }

  Future<void> _loadDevices() async {
    // Demo data
    setState(() {
      _devices
        ..clear()
        ..addAll([
          Device(
            id: '1',
            name: 'Датчик CO',
            brand: 'Acme',
            type: 'Gas',
            serialNumber: 'A123',
            isOn: true,
            emergencyStatus: 0,
            verificationDate: DateTime.now(),
          ),
          Device(
            id: '2',
            name: 'Датчик NO2',
            brand: 'Contoso',
            type: 'Gas',
            serialNumber: 'B456',
            isOn: false,
            emergencyStatus: 1,
            commissioningDate: DateTime.now(),
          ),
        ]);
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.red,
            boxShadow: [
              BoxShadow(
                color: (isActive ? Colors.green : Colors.red).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isActive 
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : const Icon(Icons.close, size: 16, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildControlPanel(),
          const Divider(height: 1),
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
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Container(width: 2, color: Colors.grey.shade600),
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
      color: Colors.grey.shade50,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _showAddDeviceDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text('Добавить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              'Всего устройств: ${_devices.length}',
              style: TextStyle(fontSize: 16, color: Colors.blue.shade800, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ====== Empty State
  Widget _buildEmptyState() {
    return const Center(
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
    );
  }

  // ====== Devices Table (Adaptive)
  Widget _buildDevicesTable(BoxConstraints constraints) {
    final sorted = _getSortedDevices();
    final columnWidth = constraints.maxWidth / 9;

    return Container(
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
                  headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
                  headingRowHeight: 56,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 72,
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  columns: [
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Название', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('name', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Марка', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('brand', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Тип', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('type', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Серийный номер', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('serialNumber', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Статус', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('isOn', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Авария', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('emergencyStatus', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Поверка', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('verificationDate', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Ввод', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      onSort: (i, a) => _sort('commissioningDate', a),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: columnWidth),
                        child: const Text('Действия', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
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
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.name, overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.brand, overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.type, overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.serialNumber, overflow: TextOverflow.ellipsis))),
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
                              isActive: d.emergencyStatus == 0, // зеленый для нормы (0), красный для аварии (1)
                              onTap: () => _toggleEmergency(d),
                              tooltip: d.emergencyStatus == 0 ? 'Норма (нажмите для аварии)' : 'Авария (нажмите для нормы)',
                            ),
                          ),
                        ),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.verificationDate?.toLocal().toString().split(' ').first ?? 'Не указана', overflow: TextOverflow.ellipsis))),
                        DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: columnWidth), child: Text(d.commissioningDate?.toLocal().toString().split(' ').first ?? 'Не указана', overflow: TextOverflow.ellipsis))),
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
      color: Colors.grey.shade100,
      child: Column(
        children: [
          // Header (кнопки управления)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconBtn('🔍+', () => _zoom(1.25), 'Увеличить'),
                const SizedBox(width: 8),
                _iconBtn('🔍-', () => _zoom(1 / 1.25), 'Уменьшить'),
                const SizedBox(width: 8),
                _iconBtn('📏', _resetView, '1:1'),
                const SizedBox(width: 16),
                // Кнопки панорамирования (можно убрать, жестами уже можно таскать)
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
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Text('Статус: ', style: TextStyle(fontWeight: FontWeight.w500)),
                Expanded(
                  child: Text(
                    _imageStatus,
                    style: TextStyle(color: Colors.blue.shade800, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Viewer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        // важно: позволяeт панорамировать даже на 1.0
                        boundaryMargin: const EdgeInsets.all(120),
                        // оставляем по умолчанию (true) — дочерний виджет ограничен рамкой
                        // этого достаточно вместе с boundaryMargin для панорамирования
                        panEnabled: true,
                        scaleEnabled: true,
                        child: Image.asset(
                          _imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _imageStatus = 'Ошибка загрузки изображения: $error';
                                });
                              }
                            });
                            return Center(
                              child: Text(
                                'Ошибка загрузки изображения',
                                style: TextStyle(color: Colors.red.shade800),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );
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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: Container(padding: const EdgeInsets.all(8), child: const Text('📅', style: TextStyle(fontSize: 16))),
        ),
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

  void _addDevice() {
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
    );
    setState(() {
      _devices.add(nd);
      _selectedDeviceId = nd.id;
    });
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Устройство "${up.name}" обновлено')));
    }
  }

  void _deleteDevice(Device d) {
    setState(() {
      _devices.removeWhere((x) => x.id == d.id);
      if (_selectedDeviceId == d.id) _selectedDeviceId = null;
    });
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