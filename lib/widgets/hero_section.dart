import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
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
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Удаленный мониторинг устройств удаленно через приложения\niOS, Android, Web, Windows, Linux, macOS. Мониторинг в реальном времени.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
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
          const SizedBox(height: 80),
          
          // Платформы и изображение - горизонтальная верстка
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1000) {
                // Большие экраны - платформы слева, изображение справа
                return Row(
                  children: [
                    // Платформы слева - вертикально
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            Icons.phone_iphone,
                            'iOS приложение\nдля iPhone и iPad',
                          ),
                          const SizedBox(height: 32),
                          _buildFeatureItem(
                            Icons.android,
                            'Android приложение\nдля смартфонов',
                          ),
                          const SizedBox(height: 32),
                          _buildFeatureItem(
                            Icons.computer,
                            'Веб-интерфейс\nдля браузера',
                          ),
                          const SizedBox(height: 32),
                          _buildFeatureItem(
                            Icons.desktop_mac,
                            'Desktop приложения\nWindows, Linux, macOS',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    // Фоновое изображение справа
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/images/back1.png',
                        fit: BoxFit.contain,
                        opacity: const AlwaysStoppedAnimation(0.8),
                      ),
                    ),
                  ],
                );
              } else if (constraints.maxWidth > 800) {
                // Средние экраны - изображение сверху, платформы снизу 2x2
                return Column(
                  children: [
                    // Фоновое изображение сверху
                    Image.asset(
                      'assets/images/back1.png',
                      height: 300,
                      fit: BoxFit.contain,
                      opacity: const AlwaysStoppedAnimation(0.8),
                    ),
                    const SizedBox(height: 40),
                    // Платформы снизу - 2x2 сетка
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureItem(
                          Icons.phone_iphone,
                          'iOS приложение\nдля iPhone и iPad',
                        ),
                        _buildFeatureItem(
                          Icons.android,
                          'Android приложение\nдля смартфонов',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureItem(
                          Icons.computer,
                          'Веб-интерфейс\nдля браузера',
                        ),
                        _buildFeatureItem(
                          Icons.desktop_mac,
                          'Desktop приложения\nWindows, Linux, macOS',
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Маленькие экраны - изображение сверху, платформы снизу вертикально
                return Column(
                  children: [
                    // Фоновое изображение сверху
                    Image.asset(
                      'assets/images/back1.png',
                      height: 250,
                      fit: BoxFit.contain,
                      opacity: const AlwaysStoppedAnimation(0.8),
                    ),
                    const SizedBox(height: 40),
                    // Платформы снизу - вертикально
                    _buildFeatureItem(
                      Icons.phone_iphone,
                      'iOS приложение\nдля iPhone и iPad',
                    ),
                    const SizedBox(height: 32),
                    _buildFeatureItem(
                      Icons.android,
                      'Android приложение\nдля смартфонов',
                    ),
                    const SizedBox(height: 32),
                    _buildFeatureItem(
                      Icons.computer,
                      'Веб-интерфейс\nдля браузера',
                    ),
                    const SizedBox(height: 32),
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

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
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
        const SizedBox(height: 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
