
import 'package:flutter/material.dart';
import 'package:ga1site/screens/devices/devices.dart';
import 'package:ga1site/screens/monitoring/monitoring.dart';
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
  Future<DeviceData?>? _futureData; // Fixed type to Future<DeviceData?>?
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
        title: Text(
          _getPageTitle(),
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.normal,
            fontSize: 22,

          ),
        ),
        backgroundColor:  Color(0xFFF4F7FE),
        foregroundColor: Color(0xFF2B3674),
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
        return 'Уведомления';
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
    return SizedBox(
      width: 240,
      child: Drawer(
        child: Column(
          children: [
          
SizedBox(
  height: 56, // например 56–64
  child: DrawerHeader(
    margin: EdgeInsets.zero,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: const BoxDecoration(color: Color(0xFFF4F7FE)),
    child: const Row(
      children: [
        Icon(Icons.admin_panel_settings, color: Color(0xFF2B3674), size: 22),
        SizedBox(width: 10),
        Text('Администратор', style: TextStyle(color: Color(0xFF2B3674), fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      ],
    ),
  ),
)
,
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
                    title: 'Уведомления',
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
        size: 16,
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.shade50,
      onTap: () {
        setState(() {
          _currentPage = page;
          if (page == 'monitoring') {
            _futureData = _apiService.fetchDeviceData(); // Refresh data
          }
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
        size: 16,
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
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
          if (page == 'monitoring') {
            _futureData = _apiService.fetchDeviceData(); // Refresh data
          }
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
    return const MonitoringPage();
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
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Здесь будет отображаться история событий системы',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
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
            'Уведомления',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Управление текстовыми уведомлениями',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
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
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Управление персоналом и правами доступа',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
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
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Статистика и аналитические отчеты',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
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
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Управление пользователями системы',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
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
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.wifi),
                        title: const Text(
                          'Сетевые настройки',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          'Конфигурация подключения',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.security),
                        title: const Text(
                          'Безопасность',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          'Настройки доступа и аутентификации',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.backup),
                        title: const Text(
                          'Резервное копирование',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          'Настройка автоматических бэкапов',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
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
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                        ),
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
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.book),
                        title: const Text(
                          'Руководство администратора',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text(
                          'FAQ',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        leading: const Icon(Icons.bug_report),
                        title: const Text(
                          'Сообщить о проблеме',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
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
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  DataRow _row(String name, UnitValue v) {
    return DataRow(cells: [
      DataCell(
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      DataCell(
        Text(
          v.value.toString(),
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      DataCell(
        Text(
          v.unit,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ]);
  }
}
