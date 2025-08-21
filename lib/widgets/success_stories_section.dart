import 'package:flutter/material.dart';

class SuccessStoriesSection extends StatelessWidget {
  const SuccessStoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
      child: Column(
        children: [
          const Text(
            'Истории успеха клиентов',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 80),
          
          // Истории успеха
          Row(
            children: [
              Expanded(
                child: _buildSuccessStory(
                  '«Газпром Нефть» сократил время реакции на аварии в 3 раза',
                  'Нефтегазовая отрасль',
                  Icons.local_gas_station,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildSuccessStory(
                  '«Роснефть» увеличил эффективность мониторинга на 40%',
                  'Нефтепереработка',
                  Icons.factory,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildSuccessStory(
                  '«Лукойл» автоматизировал 95% процессов контроля качества',
                  'Химическая промышленность',
                  Icons.science,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Смотреть все',
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

  Widget _buildSuccessStory(String title, String category, IconData icon) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1976D2),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1976D2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Читать →',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward,
                color: const Color(0xFF1976D2),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
