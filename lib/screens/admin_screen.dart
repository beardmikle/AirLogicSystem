import 'package:flutter/material.dart';
import 'package:ga1site/screens/devices/devices.dart';
import '../models/measurement.dart';
import '../services/api_service.dart';
import '../screens/maps/maps.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final ApiService _apiService;
  Future<DeviceData>? _futureData;
  String _currentPage = 'devices';

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _futureData = _apiService.fetchDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(),
      body: _buildCurrentPageContent(),
    );
  }

  String _getPageTitle() {
    switch (_currentPage) {
      case 'monitoring':
        return 'Мониторинг';
      case 'events':
        return 'Журнал событий';
      case 'messages':
        return 'Текстовые сообщения';
      case 'employees':
        return 'Сотрудники';
      case 'devices':
        return 'Устройства';
      case 'analytics':
        return 'Аналитика';
      case 'maps':
        return 'Настройка карт';
      case 'users':
        return 'Пользователи';
      case 'settings':
        return 'Параметры';
      case 'info':
        return 'Информация';
      default:
        return 'Администратор';
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(width: 16),
                Text(
                  'Панель\nАдминистратора',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.monitor,
                  title: 'Мониторинг',
                  page: 'monitoring',
                ),
                _buildDrawerItem(
                  icon: Icons.notifications,
                  title: 'Журнал событий',
                  page: 'events',
                ),
                _buildDrawerItem(
                  icon: Icons.mail,
                  title: 'Текстовые сообщения',
                  page: 'messages',
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Сотрудники',
                  page: 'employees',
                ),
                _buildDrawerItem(
                  icon: Icons.devices,
                  title: 'Устройства',
                  page: 'devices',
                ),
                _buildExpandableDrawerItem(
                  icon: Icons.analytics,
                  title: 'Аналитика',
                  page: 'analytics',
                ),
                _buildExpandableDrawerItem(
                  icon: Icons.map,
                  title: 'Настройка карт',
                  page: 'maps',
                ),
                _buildDrawerItem(
                  icon: Icons.group,
                  title: 'Пользователи',
                  page: 'users',
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Параметры',
                  page: 'settings',
                ),
                _buildExpandableDrawerItem(
                  icon: Icons.info,
                  title: 'Информация',
                  page: 'info',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String page,
  }) {
    final isSelected = _currentPage == page;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.shade50,
      onTap: () {
        setState(() {
          _currentPage = page;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildExpandableDrawerItem({
    required IconData icon,
    required String title,
    required String page,
  }) {
    final isSelected = _currentPage == page;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey.shade600,
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.shade50,
      onTap: () {
        setState(() {
          _currentPage = page;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCurrentPageContent() {
    switch (_currentPage) {
      case 'monitoring':
        return _buildMonitoringPage();
      case 'events':
        return _buildEventsPage();
      case 'messages':
        return _buildMessagesPage();
      case 'employees':
        return _buildEmployeesPage();
      case 'devices':
        return _buildDevicesPage();
      case 'analytics':
        return _buildAnalyticsPage();
      case 'maps':
        return _buildMapsPage();
      case 'users':
        return _buildUsersPage();
      case 'settings':
        return _buildSettingsPage();
      case 'info':
        return _buildInfoPage();
      default:
        return _buildMonitoringPage();
    }
  }

  Widget _buildMonitoringPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: FutureBuilder<DeviceData>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Ошибка загрузки: ${snapshot.error}');
              }
              final data = snapshot.data;
              if (data == null) {
                return const Text('Нет данных');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 8,
                        children: [
                          Text('Device ID: ${data.deviceId}',
                              style: Theme.of(context).textTheme.titleMedium),
                          Text('Timestamp: ${data.timestamp}',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                            Colors.grey.shade200),
                        border: TableBorder.all(
                            width: 1, color: Colors.grey.shade300),
                        columns: const [
                          DataColumn(label: Text('Параметр')),
                          DataColumn(label: Text('Значение')),
                          DataColumn(label: Text('Единицы')),
                        ],
                        rows: [
                          _row('CO', data.measurements.co),
                          _row('NO2', data.measurements.no2),
                          _row('Temperature', data.measurements.temperature),
                          _row('Pressure', data.measurements.pressure),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventsPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Журнал событий',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Здесь будет отображаться история событий системы',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Текстовые сообщения',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Управление текстовыми уведомлениями',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Сотрудники',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Управление персоналом и правами доступа',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesPage() {
 return const DevicesPage();
  }

  Widget _buildAnalyticsPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Аналитика',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Статистика и аналитические отчеты',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMapsPage() {
    return const MapsPage();
  }

  Widget _buildUsersPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Пользователи',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Управление пользователями системы',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Параметры системы',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const ListTile(
                        leading: Icon(Icons.wifi),
                        title: Text('Сетевые настройки'),
                        subtitle: Text('Конфигурация подключения'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      const Divider(),
                      const ListTile(
                        leading: Icon(Icons.security),
                        title: Text('Безопасность'),
                        subtitle: Text('Настройки доступа и аутентификации'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      const Divider(),
                      const ListTile(
                        leading: Icon(Icons.backup),
                        title: Text('Резервное копирование'),
                        subtitle: Text('Настройка автоматических бэкапов'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Информация о системе',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Версия ПО:', '2.1.3'),
                      _buildInfoRow('Последнее обновление:', '15.08.2025'),
                      _buildInfoRow('Лицензия:', 'Enterprise'),
                      _buildInfoRow('Поддержка:', 'support@company.com'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Документация',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      const ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Руководство администратора'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      const ListTile(
                        leading: Icon(Icons.help),
                        title: Text('FAQ'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      const ListTile(
                        leading: Icon(Icons.bug_report),
                        title: Text('Сообщить о проблеме'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  // Widget _buildCurrentPageContent() {
  //   switch (_currentPage) {
  //     case 'monitoring':
  //       return _buildMonitoringPage();
  //     case 'events':
  //       return _buildEventsPage();
  //     case 'messages':
  //       return _buildMessagesPage();
  //     case 'employees':
  //       return _buildEmployeesPage();
  //     case 'devices':
  //       return _buildDevicesPage();
  //     case 'analytics':
  //       return _buildAnalyticsPage();
  //     case 'maps':
  //       return _buildMapsPage();
  //     case 'users':
  //       return _buildUsersPage();
  //     case 'settings':
  //       return _buildSettingsPage();
  //     case 'info':
  //       return _buildInfoPage();
  //     default:
  //       return _buildMonitoringPage();
  //   }
  // }

  DataRow _row(String name, UnitValue v) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(v.value.toString())),
      DataCell(Text(v.unit)),
    ]);
  }
}