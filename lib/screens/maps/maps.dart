import 'package:flutter/material.dart';

class MapData {
  final String id;
  final String name;
  final String uri;
  final List<DeviceMarker> devices;

  MapData({
    required this.id,
    required this.name,
    required this.uri,
    this.devices = const [],
  });

  MapData copyWith({
    String? id,
    String? name,
    String? filePath,
    List<DeviceMarker>? devices,
  }) {
    return MapData(
      id: id ?? this.id,
      name: name ?? this.name,
      uri: filePath ?? uri,
      devices: devices ?? this.devices,
    );
  }
}

class DeviceMarker {
  final String id;
  final String name;
  final double x;
  final double y;

  DeviceMarker({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
  });
}

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final List<MapData> _maps = [];
  MapData? _selectedMap;
  bool _isAddingDevice = false;
  final TextEditingController _mapNameController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();

  @override
  void dispose() {
    _mapNameController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Панель управления картами
          _buildMapManagementPanel(),
          const Divider(height: 1),
          // Основная область
          Expanded(
            child: Row(
              children: [
                // Левая панель со списком карт
                SizedBox(
                  width: 300,
                  child: _buildMapsList(),
                ),
                const VerticalDivider(width: 1),
                // Основная область с картой
                Expanded(
                  child: _selectedMap == null
                      ? _buildEmptyState()
                      : _buildMapViewer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapManagementPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _showAddMapDialog,
            icon: const Icon(Icons.add),
            label: const Text('Добавить карту'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          if (_selectedMap != null) ...[
            ElevatedButton.icon(
              onPressed: _showEditMapDialog,
              icon: const Icon(Icons.edit),
              label: const Text('Редактировать'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _deleteSelectedMap,
              icon: const Icon(Icons.delete),
              label: const Text('Удалить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
          const Spacer(),
          if (_selectedMap != null)
            Row(
              children: [
                const Text('Инструменты: '),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isAddingDevice = !_isAddingDevice;
                    });
                  },
                  icon: Icon(_isAddingDevice ? Icons.cancel : Icons.location_on),
                  label: Text(_isAddingDevice ? 'Отмена' : 'Добавить устройство'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAddingDevice ? Colors.orange : Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMapsList() {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Загруженные карты',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _maps.isEmpty
                ? const Center(
                    child: Text(
                      'Нет загруженных карт',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _maps.length,
                    itemBuilder: (context, index) {
                      final map = _maps[index];
                      final isSelected = _selectedMap?.id == map.id;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: isSelected ? Colors.blue.shade50 : null,
                        child: ListTile(
                          leading: const Icon(Icons.map),
                          title: Text(
                            map.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : null,
                              color: isSelected ? Colors.blue.shade700 : null,
                            ),
                          ),
                          subtitle: Text(
                            '${map.devices.length} устройств',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.blue.shade700)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedMap = map;
                              _isAddingDevice = false;
                            });
                          },
                        ),
                      );
                    },
                  ),
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
          Icon(Icons.map, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Выберите карту для просмотра',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Добавьте новую карту или выберите из списка',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMapViewer() {
    return Column(
      children: [
        // Информация о карте и панель устройств
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedMap!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Устройств на карте: ${_selectedMap!.devices.length}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (_isAddingDevice)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Нажмите на карту для размещения устройства',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Область карты
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTapUp: _isAddingDevice ? _handleMapTap : null,
                child: Stack(
                  children: [
                    // Имитация PDF карты (можно заменить на реальный PDF viewer)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade200, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, 
                                 size: 48, color: Colors.grey.shade600),
                            const SizedBox(height: 8),
                            Text(
                              _selectedMap!.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedMap!.uri,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Устройства на карте
                    ..._selectedMap!.devices.map((device) {
                      return Positioned(
                        left: device.x,
                        top: device.y,
                        child: GestureDetector(
                          onTap: () => _showDeviceInfo(device),
                          child: Container(
                            transform: Matrix4.translationValues(-12, -24, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.red),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    device.name,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleMapTap(TapUpDetails details) {
    if (!_isAddingDevice || _selectedMap == null) return;

    _showAddDeviceDialog(details.localPosition.dx, details.localPosition.dy);
  }

  void _showAddMapDialog() {
    _mapNameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить карту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _mapNameController,
              decoration: const InputDecoration(
                labelText: 'Название карты',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.picture_as_pdf, size: 32, color: Colors.green.shade700),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Карта будет загружена из:',
                  //   style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   'maps/map1.pdf',
                  //   style: TextStyle(color: Colors.green.shade600, fontSize: 12),
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: _addMap,
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditMapDialog() {
    if (_selectedMap == null) return;
    
    _mapNameController.text = _selectedMap!.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать карту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _mapNameController,
              decoration: const InputDecoration(
                labelText: 'Название карты',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.picture_as_pdf, size: 32, color: Colors.blue.shade700),
                  const SizedBox(height: 8),
                  Text(
                    'Текущий файл карты:',
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedMap!.uri,
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: _editMap,
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceDialog(double x, double y) {
    _deviceNameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить устройство'),
        content: TextField(
          controller: _deviceNameController,
          decoration: const InputDecoration(
            labelText: 'Название устройства',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => _addDevice(x, y),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showDeviceInfo(DeviceMarker device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${device.id}'),
            Text('Координаты: ${device.x.toStringAsFixed(1)}, ${device.y.toStringAsFixed(1)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _removeDevice(device),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _selectPdfFile() {
    // Имитация выбора файла
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Выбор PDF файла (функция для примера)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addMap() {
    if (_mapNameController.text.trim().isEmpty) return;

    final newMap = MapData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _mapNameController.text.trim(),
      uri: 'http://localhost:8000/static/map1.pdf',
    );

    setState(() {
      _maps.add(newMap);
      _selectedMap = newMap;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Карта "${newMap.name}" добавлена из http://localhost:8000/static/map1.pdf')),
    );
  }

  void _editMap() {
    if (_selectedMap == null || _mapNameController.text.trim().isEmpty) return;

    setState(() {
      final index = _maps.indexWhere((m) => m.id == _selectedMap!.id);
      if (index != -1) {
        _maps[index] = _selectedMap!.copyWith(name: _mapNameController.text.trim());
        _selectedMap = _maps[index];
      }
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Карта обновлена')),
    );
  }

  void _deleteSelectedMap() {
    if (_selectedMap == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить карту'),
        content: Text('Вы уверены, что хотите удалить карту "${_selectedMap!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _maps.removeWhere((m) => m.id == _selectedMap!.id);
                _selectedMap = null;
                _isAddingDevice = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Карта удалена')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _addDevice(double x, double y) {
    if (_selectedMap == null || _deviceNameController.text.trim().isEmpty) return;

    final newDevice = DeviceMarker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _deviceNameController.text.trim(),
      x: x,
      y: y,
    );

    setState(() {
      final updatedDevices = List<DeviceMarker>.from(_selectedMap!.devices)..add(newDevice);
      final index = _maps.indexWhere((m) => m.id == _selectedMap!.id);
      _maps[index] = _selectedMap!.copyWith(devices: updatedDevices);
      _selectedMap = _maps[index];
      _isAddingDevice = false;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Устройство "${newDevice.name}" добавлено')),
    );
  }

  void _removeDevice(DeviceMarker device) {
    if (_selectedMap == null) return;

    setState(() {
      final updatedDevices = _selectedMap!.devices.where((d) => d.id != device.id).toList();
      final index = _maps.indexWhere((m) => m.id == _selectedMap!.id);
      _maps[index] = _selectedMap!.copyWith(devices: updatedDevices);
      _selectedMap = _maps[index];
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Устройство "${device.name}" удалено')),
    );
  }
}