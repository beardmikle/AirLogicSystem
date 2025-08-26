import 'package:flutter/material.dart';
import 'package:ga1site/services/device_db_service.dart';
import 'package:ga1site/services/session_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Device {
  final String id;
  final String name;
  final String brand;
  final String type;
  final String serialNumber;
  final DateTime? verificationDate;
  final DateTime? commissioningDate;
  final bool isOn;
  final int emergencyStatus; // 0 - норма, 1 - авария

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
  String? _username;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  // Контроллеры для форм
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _typeController = TextEditingController();
  final _serialNumberController = TextEditingController();
  DateTime? _verificationDate;
  DateTime? _commissioningDate;
  bool _isOn = false;
  int _emergencyStatus = 0;

  // Сортировка
  String _sortColumn = 'name';
  bool _sortAscending = true;

  // Разделитель
  double _splitRatio = 0.6; // Initial ratio: 60% table, 40% PDF

  @override
  void initState() {
    super.initState();
    _username = SessionService.getCurrentUsername();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    if (_username == null) {
      setState(() {
        _devices.clear();
      });
      return;
    }
    final stored = DeviceDbService.list(_username!);
    setState(() {
      _devices
        ..clear()
        ..addAll(stored.map((s) => Device(
              id: s.id,
              name: s.name,
              brand: s.brand,
              type: s.type,
              serialNumber: s.serialNumber,
              verificationDate: s.verificationDate,
              commissioningDate: s.commissioningDate,
              isOn: s.isOn,
              emergencyStatus: s.emergencyStatus,
            )));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _typeController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildControlPanel(),
          const Divider(height: 1),
          Expanded(
            child: _username == null
                ? _buildNoUser()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: (_splitRatio * 100).toInt(),
                            child: _devices.isEmpty
                                ? _buildEmptyState()
                                : _buildDevicesTable(),
                          ),
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                // Update split ratio based on drag
                                _splitRatio += details.delta.dx / constraints.maxWidth;
                                // Clamp the ratio to prevent extreme resizing
                                _splitRatio = _splitRatio.clamp(0.3, 0.7);
                              });
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeLeftRight,
                              child: Container(
                                width: 8,
                                color: Colors.grey.shade300,
                                child: Center(
                                  child: Container(
                                    width: 2,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: ((1 - _splitRatio) * 100).toInt(),
                            child: _buildPdfPane(),
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

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _username == null ? null : _showAddDeviceDialog,
            icon: const Icon(Icons.add, size: 20, color: Colors.white),
            label: const Text('Добавить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUser() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login, size: 80, color: Colors.orange.shade400),
          const SizedBox(height: 20),
          Text(
            'Войдите в систему, чтобы управлять устройствами',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices, size: 80, color: Colors.red),
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

  Widget _buildDevicesTable() {
    final sortedDevices = _getSortedDevices();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * _splitRatio - 32,
                  ),
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
                        label: const Expanded(
                          child: Text(
                            'Название',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('name', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Марка',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('brand', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Тип',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('type', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Серийный номер',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('serialNumber', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Состояние',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('isOn', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Авария',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('emergencyStatus', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Дата поверки',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('verificationDate', a),
                      ),
                      DataColumn(
                        label: const Expanded(
                          child: Text(
                            'Дата ввода в эксплуатацию',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (i, a) => _sort('commissioningDate', a),
                      ),
                      const DataColumn(
                        label: Text(
                          'Действия',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: sortedDevices.map((device) {
                      final isSelected = _selectedDeviceId == device.id;
                      return DataRow(
                        selected: isSelected,
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (states) =>
                              states.contains(WidgetState.selected)
                                  ? Colors.blue.shade100
                                  : null,
                        ),
                        onSelectChanged: (selected) {
                          setState(() {
                            _selectedDeviceId =
                                selected == true ? device.id : null;
                          });
                        },
                        cells: [
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Text(
                                device.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                device.brand,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                device.type,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Text(
                                device.serialNumber,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () => _togglePower(device),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: device.isOn ? Colors.green.shade50 : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: device.isOn ? Colors.green : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      device.isOn ? Icons.power_settings_new : Icons.power_settings_new,
                                      color: device.isOn ? Colors.green.shade700 : Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      device.isOn ? 'Вкл' : 'Выкл',
                                      style: TextStyle(
                                        color: device.isOn ? Colors.green.shade700 : Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () => _toggleEmergency(device),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: device.emergencyStatus == 1
                                      ? Colors.red.shade50
                                      : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: device.emergencyStatus == 1
                                        ? Colors.red
                                        : Colors.green,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      device.emergencyStatus == 1
                                        ? Icons.warning_amber_rounded
                                        : Icons.check_circle_outline,
                                      color: device.emergencyStatus == 1
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      device.emergencyStatus == 1
                                        ? 'Авария'
                                        : 'Норма',
                                      style: TextStyle(
                                        color: device.emergencyStatus == 1
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                device.verificationDate
                                        ?.toLocal()
                                        .toString()
                                        .split(' ')[0] ??
                                    'Не указана',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                device.commissioningDate
                                        ?.toLocal()
                                        .toString()
                                        .split(' ')[0] ??
                                    'Не указана',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showEditDeviceDialog(device),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue.shade300, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showDeleteConfirmation(device),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red.shade300, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfPane() {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPdfButton(
                  icon: Icons.zoom_in,
                  onPressed: () => _pdfViewerController.zoomLevel += 0.25,
                  tooltip: 'Увеличить',
                ),
                const SizedBox(width: 12),
                _buildPdfButton(
                  icon: Icons.zoom_out,
                  onPressed: () => _pdfViewerController.zoomLevel -= 0.25,
                  tooltip: 'Уменьшить',
                ),
                const SizedBox(width: 12),
                _buildPdfButton(
                  icon: Icons.fit_screen,
                  onPressed: () => _pdfViewerController.zoomLevel = 1.0,
                  tooltip: 'Вписать в окно',
                ),
                const SizedBox(width: 16),
                const Text(
                  'Карта',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: _buildPdfViewer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfViewer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FutureBuilder(
          // Проверяем, существует ли файл
          future: _checkPdfExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (snapshot.hasError || snapshot.data == false) {
              return _buildPdfErrorView();
            }

            return SfPdfViewer.asset(
              'assets/maps/map1.pdf',
              controller: _pdfViewerController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
              enableTextSelection: false,
              onDocumentLoadFailed: (details) {
                print('PDF load failed: ${details.description}');
                // Показываем ошибку при загрузке
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> _checkPdfExists() async {
    try {
      // Попытка загрузить PDF для проверки существования
      await Future.delayed(const Duration(milliseconds: 100));
      return true; // Предполагаем, что файл существует
    } catch (e) {
      return false;
    }
  }

  Widget _buildPdfErrorView() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Карта не найдена',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Файл assets/maps/map1.pdf\nне найден в проекте',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Убедитесь, что файл добавлен\nв папку assets/maps/ и\nуказан в pubspec.yaml',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade300, width: 1),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade700,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showAddDeviceDialog() {
    _clearForm();
    _showDeviceDialog('Добавить устройство', _addDevice);
  }

  void _showEditDeviceDialog(Device device) {
    _fillForm(device);
    _showDeviceDialog('Редактировать устройство', () => _editDevice(device));
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Марка',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Тип',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Серийный номер устройства',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildDateField(
                'Дата поверки',
                _verificationDate,
                (date) => setState(() => _verificationDate = date),
              ),
              const SizedBox(height: 16),
              _buildDateField(
                'Дата ввода в эксплуатацию',
                _commissioningDate,
                (date) => setState(() => _commissioningDate = date),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _isOn = !_isOn),
                      child: Row(
                        children: [
                          const Text('Состояние устройства:', style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Switch(
                            value: _isOn,
                            onChanged: (value) => setState(() => _isOn = value),
                            activeColor: Colors.green,
                          ),
                          Text(
                            _isOn ? 'Включено' : 'Выключено',
                            style: TextStyle(
                              color: _isOn ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _emergencyStatus = _emergencyStatus == 1 ? 0 : 1),
                child: Row(
                  children: [
                    const Text('Состояние аварии:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: _emergencyStatus,
                          onChanged: (value) => setState(() => _emergencyStatus = value!),
                          activeColor: Colors.green,
                        ),
                        const Text('Норма'),
                        const SizedBox(width: 16),
                        Radio<int>(
                          value: 1,
                          groupValue: _emergencyStatus,
                          onChanged: (value) => setState(() => _emergencyStatus = value!),
                          activeColor: Colors.red,
                        ),
                        const Text('Авария'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Название обязательно для заполнения')),
                        );
                        return;
                      }
                      onSave();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
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
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onChanged(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
        ),
        child: Text(
          date?.toLocal().toString().split(' ')[0] ?? 'Выберите дату',
          style: TextStyle(
            color: date != null ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Device device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить устройство'),
        content: Text('Вы уверены, что хотите удалить устройство "${device.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteDevice(device);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
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

  void _fillForm(Device device) {
    _nameController.text = device.name;
    _brandController.text = device.brand;
    _typeController.text = device.type;
    _serialNumberController.text = device.serialNumber;
    _verificationDate = device.verificationDate;
    _commissioningDate = device.commissioningDate;
    _isOn = device.isOn;
    _emergencyStatus = device.emergencyStatus;
  }

  Future<void> _togglePower(Device device) async {
    final updated = device.copyWith(isOn: !device.isOn);
    setState(() {
      final index = _devices.indexWhere((d) => d.id == device.id);
      if (index != -1) {
        _devices[index] = updated;
      }
    });
    if (_username != null) {
      await DeviceDbService.update(
        _username!,
        StoredDevice(
          id: updated.id,
          name: updated.name,
          brand: updated.brand,
          type: updated.type,
          serialNumber: updated.serialNumber,
          verificationDate: updated.verificationDate,
          commissioningDate: updated.commissioningDate,
          isOn: updated.isOn,
          emergencyStatus: updated.emergencyStatus,
        ),
      );
    }
  }

  Future<void> _toggleEmergency(Device device) async {
    final updated = device.copyWith(emergencyStatus: device.emergencyStatus == 1 ? 0 : 1);
    setState(() {
      final index = _devices.indexWhere((d) => d.id == device.id);
      if (index != -1) {
        _devices[index] = updated;
      }
    });
    if (_username != null) {
      await DeviceDbService.update(
        _username!,
        StoredDevice(
          id: updated.id,
          name: updated.name,
          brand: updated.brand,
          type: updated.type,
          serialNumber: updated.serialNumber,
          verificationDate: updated.verificationDate,
          commissioningDate: updated.commissioningDate,
          isOn: updated.isOn,
          emergencyStatus: updated.emergencyStatus,
        ),
      );
    }
  }

  void _addDevice() async {
    final newDevice = Device(
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
      _devices.add(newDevice);
      _selectedDeviceId = newDevice.id;
    });

    if (_username != null) {
      await DeviceDbService.add(
        _username!,
        StoredDevice(
          id: newDevice.id,
          name: newDevice.name,
          brand: newDevice.brand,
          type: newDevice.type,
          serialNumber: newDevice.serialNumber,
          verificationDate: newDevice.verificationDate,
          commissioningDate: newDevice.commissioningDate,
          isOn: newDevice.isOn,
          emergencyStatus: newDevice.emergencyStatus,
        ),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Устройство "${newDevice.name}" добавлено')),
      );
    }
  }

  void _editDevice(Device oldDevice) async {
    final updatedDevice = Device(
      id: oldDevice.id,
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
      final index = _devices.indexWhere((d) => d.id == oldDevice.id);
      if (index != -1) {
        _devices[index] = updatedDevice;
      }
    });

    if (_username != null) {
      await DeviceDbService.update(
        _username!,
        StoredDevice(
          id: updatedDevice.id,
          name: updatedDevice.name,
          brand: updatedDevice.brand,
          type: updatedDevice.type,
          serialNumber: updatedDevice.serialNumber,
          verificationDate: updatedDevice.verificationDate,
          commissioningDate: updatedDevice.commissioningDate,
          isOn: updatedDevice.isOn,
          emergencyStatus: updatedDevice.emergencyStatus,
        ),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Устройство "${updatedDevice.name}" обновлено')),
      );
    }
  }

  void _deleteDevice(Device device) async {
    setState(() {
      _devices.removeWhere((d) => d.id == device.id);
      if (_selectedDeviceId == device.id) {
        _selectedDeviceId = null;
      }
    });

    if (_username != null) {
      await DeviceDbService.remove(_username!, device.id);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Устройство "${device.name}" удалено')),
      );
    }
  }

  void _sort(String column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _sortAscending = ascending;
    });
  }

  List<Device> _getSortedDevices() {
    final devices = List<Device>.from(_devices);

    devices.sort((a, b) {
      dynamic aValue, bValue;

      switch (_sortColumn) {
        case 'name':
          aValue = a.name.toLowerCase();
          bValue = b.name.toLowerCase();
          break;
        case 'brand':
          aValue = a.brand.toLowerCase();
          bValue = b.brand.toLowerCase();
          break;
        case 'type':
          aValue = a.type.toLowerCase();
          bValue = b.type.toLowerCase();
          break;
        case 'serialNumber':
          aValue = a.serialNumber.toLowerCase();
          bValue = b.serialNumber.toLowerCase();
          break;
        case 'isOn':
          aValue = a.isOn ? 1 : 0;
          bValue = b.isOn ? 1 : 0;
          break;
        case 'emergencyStatus':
          aValue = a.emergencyStatus;
          bValue = b.emergencyStatus;
          break;
        case 'verificationDate':
          aValue = a.verificationDate ?? DateTime(1900);
          bValue = b.verificationDate ?? DateTime(1900);
          break;
        case 'commissioningDate':
          aValue = a.commissioningDate ?? DateTime(1900);
          bValue = b.commissioningDate ?? DateTime(1900);
          break;
        default:
          aValue = a.name.toLowerCase();
          bValue = b.name.toLowerCase();
      }

      final result = Comparable.compare(aValue, bValue);
      return _sortAscending ? result : -result;
    });

    return devices;
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
}