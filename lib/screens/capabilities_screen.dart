import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class CapabilitiesScreen extends StatelessWidget {
  const CapabilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeader(),
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXXXLarge,
                vertical: AppSizes.paddingXXLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Возможности', style: AppTextStyles.heading1),
                  const SizedBox(height: AppSizes.marginLarge),
                  Text(
                    'Удалённый мониторинг газоанализаторов семейства ГАНК через платформу AirLogicSystem',
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXXXLarge,
                vertical: AppSizes.paddingXXLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Что даёт удалённый мониторинг ГАНК', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSizes.marginLarge),
                  _FeatureRow(
                    icon: Icons.sensors,
                    title: 'Онлайн‑контроль параметров',
                    description:
                        'Текущие показания, статусы, самодиагностика и журналы событий — в едином веб‑интерфейсе.',
                  ),
                  _FeatureRow(
                    icon: Icons.notifications_active,
                    title: 'Оповещения и пороговые срабатывания',
                    description:
                        'Гибкая настройка порогов, мгновенные уведомления по e‑mail/мессенджерам и в интерфейсе.',
                  ),
                  _FeatureRow(
                    icon: Icons.query_stats,
                    title: 'Тренды и отчёты',
                    description:
                        'Исторические графики концентраций и состояний, экспорт отчётов для аудита и анализа.',
                  ),
                  _FeatureRow(
                    icon: Icons.build_circle,
                    title: 'Удалённое обслуживание',
                    description:
                        'Подсказки по калибровке, планирование ТО, контроль ресурса датчиков и расходных материалов.',
                  ),
                  _FeatureRow(
                    icon: Icons.security,
                    title: 'Безопасность и права доступа',
                    description:
                        'Разграничение ролей, шифрование каналов, аудит действий пользователей.',
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXXXLarge,
                vertical: AppSizes.paddingXXLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Как это работает', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSizes.marginLarge),
                  Text(
                    'Газоанализаторы ГАНК подключаются к защищённому шлюзу AirLogicSystem.\n'
                    'Данные передаются по зашифрованным каналам в облако, агрегируются и визуализируются.\n'
                    'Интерфейс предоставляет доступ к устройствам, журналам, оповещениям и отчётам. API доступен для интеграций.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXXXLarge,
                vertical: AppSizes.paddingXXLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Поддерживаемые сценарии', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSizes.marginLarge),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      _ScenarioChip(text: 'Непрерывный мониторинг концентраций'),
                      _ScenarioChip(text: 'Раннее выявление отклонений'),
                      _ScenarioChip(text: 'Планово‑предупредительное обслуживание'),
                      _ScenarioChip(text: 'Интеграция с АСУ ТП/EMS/CMMS'),
                      _ScenarioChip(text: 'Отчётность для надзора и аудита'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXXXLarge,
                vertical: AppSizes.paddingXXLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Готовы подключить ГАНК к AirLogicSystem?', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.marginMedium),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      ),
                    ),
                    child: const Text('Связаться с нами'),
                  ),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.marginLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Text(description, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioChip extends StatelessWidget {
  final String text;
  const _ScenarioChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(text, style: AppTextStyles.bodySmall),
    );
  }
}


