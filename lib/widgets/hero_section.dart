import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1976D2).withOpacity(0.08),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Удаленный мониторинг\nустройств',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Удаленный мониторинг устройств через приложения\niOS, Android, Web, Windows, Linux, macOS. Мониторинг в реальном времени.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Демо'),
              ),
              const SizedBox(width: 24),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50),
                  side: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Пробный период'),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Платформы и изображение
          LayoutBuilder(
            builder: (context, constraints) {
              final isLarge = constraints.maxWidth > 1000;
              final isMedium = constraints.maxWidth > 800 && constraints.maxWidth <= 1000;

              if (isLarge) {
                // Большие экраны — слева 2x2 сетка иконок, справа изображение
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // выравнивание по верхнему краю
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildFeatureGrid(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topCenter, // чтобы картинка тоже тянулась вверх
                        child: Image.asset(
                          'assets/images/back1.png',
                          fit: BoxFit.fitHeight,
                          opacity: const AlwaysStoppedAnimation(0.8),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (isMedium) {
                // Средние экраны — сверху изображение, ниже 2x2 сетка
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/back1.png',
                        height: 220,
                        fit: BoxFit.contain,
                        opacity: const AlwaysStoppedAnimation(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureGrid(),
                  ],
                );
              } else {
                // Маленькие экраны — изображение + вертикальный список
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/back1.png',
                        height: 250,
                        fit: BoxFit.contain,
                        opacity: const AlwaysStoppedAnimation(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      Icons.phone_iphone,
                      'iOS приложение\nдля iPhone и iPad',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      Icons.android,
                      'Android приложение\nдля смартфонов',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      Icons.computer,
                      'Веб-интерфейс\nдля браузера',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      Icons.desktop_mac,
                      'Desktop приложения\nWindows, Linux, macOS',
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // 2x2 сетка из _buildFeatureItem
  Widget _buildFeatureGrid() {
    final items = <Widget>[
      _buildFeatureItem(Icons.phone_iphone, 'iOS приложение\nдля iPhone и iPad'),
      _buildFeatureItem(Icons.android, 'Android приложение\nдля смартфонов'),
      _buildFeatureItem(Icons.computer, 'Веб-интерфейс\nдля браузера'),
      _buildFeatureItem(Icons.desktop_mac, 'Desktop приложения\nWindows, Linux, macOS'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
      childAspectRatio: 1.8,
      children: items,
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
