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
          const SizedBox(height: 48),
          
          // Адаптивный лэйаут: на больших экранах показываем QR-панель справа, на маленьких снизу
          LayoutBuilder(
            builder: (context, constraints) {
              final isLarge = constraints.maxWidth > 1200;
              final isMedium = constraints.maxWidth > 800 && constraints.maxWidth <= 1200;

              final storiesGrid = _StoriesGrid(columns: isLarge ? 3 : (isMedium ? 2 : 1));
               

              if (isLarge) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Истории — шире
                    Expanded(flex: 3, child: storiesGrid),
                    const SizedBox(width: 32),
                    // QR — уже
                  
                  ],
                );
              }

              // Средние и малые — сначала истории, затем QR
              return Column(
                children: [
                  storiesGrid,
                  const SizedBox(height: 32),
                   
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StoriesGrid extends StatelessWidget {
  final int columns;
  const _StoriesGrid({required this.columns});

  @override
  Widget build(BuildContext context) {
    // Три карточки, как раньше, но в гибкой сетке
    final items = <Widget>[
      _buildSuccessStory(
        '«Газпром Нефть» сократил время реакции на аварии в 3 раза',
        'Нефтегазовая отрасль',
        Icons.local_gas_station,
      ),
      _buildSuccessStory(
        '«Роснефть» увеличил эффективность мониторинга на 40%',
        'Нефтепереработка',
        Icons.factory,
      ),
      _buildSuccessStory(
        '«Лукойл» автоматизировал 95% процессов контроля качества',
        'Химическая промышленность',
        Icons.science,
      ),
    ];

    if (columns == 1) {
      return Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1) const SizedBox(height: 24),
          ]
        ],
      );
    }

    if (columns == 2) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: items[0]),
              const SizedBox(width: 24),
              Expanded(child: items[1]),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: items[2]),
              const SizedBox(width: 24),
              // Пустой заполнитель, чтобы выровнять сетку
              Expanded(child: Container()),
            ],
          ),
        ],
      );
    }

    // columns == 3
    return Row(
      children: [
        Expanded(child: items[0]),
        const SizedBox(width: 24),
        Expanded(child: items[1]),
        const SizedBox(width: 24),
        Expanded(child: items[2]),
      ],
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



class _QrTile extends StatelessWidget {
  final String label;
  final IconData icon;
  const _QrTile({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  spreadRadius: 1,
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.qr_code, size: 72, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1976D2)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreBadge extends StatelessWidget {
  final String label;
  const _StoreBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.download, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
