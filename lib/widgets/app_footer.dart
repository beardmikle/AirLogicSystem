import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
      ),
      child: Column(
        children: [
          // Основные ссылки
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         const Text(
                       'AirLogicSystem',
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                     ),
                    const SizedBox(height: 24),
                                         _buildFooterLink('Все решения'),
                     _buildFooterLink('Партнерская программа'),
                     _buildFooterLink('Партнерство'),
                     _buildFooterLink('О компании'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Продукт',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                                         _buildFooterLink('Возможности'),
                     _buildFooterLink('Интеграция'),
                     _buildFooterLink('Цены'),
                     _buildFooterLink('Калькулятор ROI'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Клиенты',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                                         _buildFooterLink('Истории успеха клиентов'),
                     _buildFooterLink('Отраслевые решения'),
                     _buildFooterLink('Документация'),
                     _buildFooterLink('Партнерство'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Поддержка',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                                         _buildFooterLink('Центр поддержки'),
                     _buildFooterLink('8 800 123-45-67'),
                     _buildFooterLink('Заказать звонок'),
                     _buildFooterLink('Написать в чат'),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 60),
          
          // Разделитель
          Container(
            height: 1,
            color: Colors.grey[800],
          ),
          
          const SizedBox(height: 40),
          
          // Нижняя часть
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    '© 2025 AirLogicSystem',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  // Социальные сети
                  Row(
                    children: [
                      _buildSocialIcon(Icons.facebook, Colors.blue),
                      const SizedBox(width: 16),
                      _buildSocialIcon(Icons.telegram, Colors.lightBlue),
                      const SizedBox(width: 16),
                      _buildSocialIcon(Icons.chat, Colors.green),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Используем cookies для корректной работы сайта, персонализации пользователей и других целей, предусмотренных политикой обработки персональных данных.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Дополнительные ссылки
          Row(
            children: [
              _buildFooterLink('In English', color: Colors.grey),
              const SizedBox(width: 40),
              _buildFooterLink('API документация', color: Colors.grey),
              const SizedBox(width: 40),
              _buildFooterLink('Скачать приложения', color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.grey[300],
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}
