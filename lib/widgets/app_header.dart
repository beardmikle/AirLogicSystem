import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              // Логотип
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(
                        'AirLogicSystem',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Навигация
              Row(
                children: [
                  _buildNavItem(context, 'Возможности', '/capabilities'),
                  // _buildNavItem(context, 'Платформы', null),
                  // _buildNavItem(context, 'Цены', null),
                  // _buildNavItem(context, 'Интеграция', null),
                  // _buildNavItem(context, 'Документация', null),
                ],
              ),
              
              const SizedBox(width: 32),
              
              // Кнопки
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => const LoginDialog(),
                      );
                      if (result == true && context.mounted) {
                        Navigator.of(context).pushNamed('/admin');
                      }
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Color(0xFF1976D2),
                      size: 20,
                    ),
                    label: const Text(
                      'Войти',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String? routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: routeName == null
            ? null
            : () {
                Navigator.of(context).pushNamed(routeName);
              },
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}