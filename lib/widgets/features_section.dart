import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
      child: Column(
        children: [
          const Text(
            'Возможности системы',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 80),
          
          // Основные возможности - адаптивные
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                // Большие экраны - 3 колонки
                return Row(
                  children: [
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.analytics,
                        'Мониторинг в реальном времени',
                        'Отслеживайте показатели газоанализаторов в реальном времени с любого устройства',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.settings_remote,
                        'Удаленное управление',
                        'Управляйте настройками и параметрами газоанализаторов удаленно',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.notifications_active,
                        'Уведомления и оповещения',
                        'Получайте мгновенные уведомления о критических изменениях и авариях',
                      ),
                    ),
                  ],
                );
              } else if (constraints.maxWidth > 800) {
                // Средние экраны - 2x2 сетка
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.analytics,
                            'Мониторинг в реальном времени',
                            'Отслеживайте показатели газоанализаторов в реальном времени с любого устройства',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.settings_remote,
                            'Удаленное управление',
                            'Управляйте настройками и параметрами газоанализаторов удаленно',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureCard(
                      Icons.notifications_active,
                      'Уведомления и оповещения',
                      'Получайте мгновенные уведомления о критических изменениях и авариях',
                    ),
                  ],
                );
              } else {
                // Маленькие экраны - вертикально
                return Column(
                  children: [
                    _buildFeatureCard(
                      Icons.analytics,
                      'Мониторинг в реальном времени',
                      'Отслеживайте показатели газоанализаторов в реальном времени с любого устройства',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureCard(
                      Icons.settings_remote,
                      'Удаленное управление',
                      'Управляйте настройками и параметрами газоанализаторов удаленно',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureCard(
                      Icons.notifications_active,
                      'Уведомления и оповещения',
                      'Получайте мгновенные уведомления о критических изменениях и авариях',
                    ),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 80),
          
          // Дополнительные возможности - адаптивные
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1000) {
                // Большие экраны - 3 колонки
                return Row(
                  children: [
                    Expanded(
                      child: _buildDetailedFeature(
                        Icons.history,
                        'История измерений',
                        'Храните и анализируйте историю всех измерений и изменений',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailedFeature(
                        Icons.assessment,
                        'Отчеты и аналитика',
                        'Генерируйте детальные отчеты и аналитические данные',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailedFeature(
                        Icons.integration_instructions,
                        'Интеграция с системами',
                        'Интегрируйтесь с существующими SCADA и ERP системами',
                      ),
                    ),
                  ],
                );
              } else if (constraints.maxWidth > 600) {
                // Средние экраны - 2x2 сетка
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailedFeature(
                            Icons.history,
                            'История измерений',
                            'Храните и анализируйте историю всех измерений и изменений',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildDetailedFeature(
                            Icons.assessment,
                            'Отчеты и аналитика',
                            'Генерируйте детальные отчеты и аналитические данные',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailedFeature(
                      Icons.integration_instructions,
                      'Интеграция с системами',
                      'Интегрируйтесь с существующими SCADA и ERP системами',
                    ),
                  ],
                );
              } else {
                // Маленькие экраны - вертикально
                return Column(
                  children: [
                    _buildDetailedFeature(
                      Icons.history,
                      'История измерений',
                      'Храните и анализируйте историю всех измерений и изменений',
                    ),
                    const SizedBox(height: 24),
                    _buildDetailedFeature(
                      Icons.assessment,
                      'Отчеты и аналитика',
                      'Генерируйте детальные отчеты и аналитические данные',
                    ),
                    const SizedBox(height: 24),
                    _buildDetailedFeature(
                      Icons.integration_instructions,
                      'Интеграция с системами',
                      'Интегрируйтесь с существующими SCADA и ERP системами',
                    ),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 48),
          
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Подробнее',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedFeature(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 32,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
