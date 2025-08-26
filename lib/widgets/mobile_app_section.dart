import 'package:flutter/material.dart';

class MobileAppSection extends StatelessWidget {
  const MobileAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 768;
          
          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTextContent(),
                ),
                const SizedBox(width: 80),
                Expanded(
                  flex: 1,
                  child: _buildDownloadSection(),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextContent(),
                const SizedBox(height: 40),
                _buildDownloadSection(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Мобильные приложения',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Управляйте мониторингом устройств с iPhone, iPad, Android устройств. Получайте уведомления, просматривайте данные и управляйте настройками в реальном времени.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadSection() {
    return _buildDownloadPanel();
  }

  Widget _buildDownloadPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Скачать приложения',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 500;
              
              if (isMobile) {
                return Column(
                  children: [
                    _QrTile(
                      label: 'iOS',
                      platform: 'ios',
                      onTap: () {
                        // Обработка нажатия на iOS
                      },
                    ),
                    const SizedBox(height: 16),
                    _QrTile(
                      label: 'Android',
                      platform: 'android',
                      onTap: () {
                        // Обработка нажатия на Android
                      },
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _QrTile(
                        label: 'iOS',
                        platform: 'ios',
                        onTap: () {
                          // Обработка нажатия на iOS
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QrTile(
                        label: 'Android',
                        platform: 'android',
                        onTap: () {
                          // Обработка нажатия на Android
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StoreBadge(
                  label: 'App Store',
                  onTap: () {
                    // Переход в App Store
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StoreBadge(
                  label: 'Google Play',
                  onTap: () {
                    // Переход в Google Play
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QrTile extends StatelessWidget {
  final String label;
  final String platform;
  final VoidCallback? onTap;

  const _QrTile({
    required this.label,
    required this.platform,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // QR код
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'QR',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Иконка платформы
            Icon(
              platform == 'ios' ? Icons.apple : Icons.android,
              size: 24,
              color: const Color(0xFF1976D2),
            ),
            const SizedBox(height: 8),
            // Название платформы
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Сканировать QR-код',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreBadge extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _StoreBadge({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1976D2).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.download,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}