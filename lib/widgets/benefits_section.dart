import 'package:flutter/material.dart';
import 'pie_chart.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
      child: Column(
        children: [
          const Text(
            'Интеллектуальное управление\nгазоанализаторами',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 80),
          
          // Преимущества в виде карточек - адаптивные
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                // Большие экраны - 4 колонки
                return Row(
                  children: [
                    Expanded(
                      child: _buildBenefitCard(
                        Icons.wifi,
                        'Удаленное управление\nиз любой точки мира',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildBenefitCard(
                        Icons.schedule,
                        'Мониторинг в реальном\nвремени 24/7',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildBenefitCard(
                        Icons.security,
                        'Безопасное соединение\nс шифрованием данных',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildBenefitCard(
                        Icons.auto_fix_high,
                        'Автоматические уведомления\nи отчеты',
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
                          child: _buildBenefitCard(
                            Icons.wifi,
                            'Удаленное управление\nиз любой точки мира',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildBenefitCard(
                            Icons.schedule,
                            'Мониторинг в реальном\nвремени 24/7',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBenefitCard(
                            Icons.security,
                            'Безопасное соединение\nс шифрованием данных',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildBenefitCard(
                            Icons.auto_fix_high,
                            'Автоматические уведомления\nи отчеты',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Маленькие экраны - вертикально
                return Column(
                  children: [
                    _buildBenefitCard(
                      Icons.wifi,
                      'Удаленное управление\nиз любой точки мира',
                    ),
                    const SizedBox(height: 24),
                    _buildBenefitCard(
                      Icons.schedule,
                      'Мониторинг в реальном\nвремени 24/7',
                    ),
                    const SizedBox(height: 24),
                    _buildBenefitCard(
                      Icons.security,
                      'Безопасное соединение\nс шифрованием данных',
                    ),
                    const SizedBox(height: 24),
                    _buildBenefitCard(
                      Icons.auto_fix_high,
                      'Автоматические уведомления\nи отчеты',
                    ),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 80),
          
          // Статистика — три диаграммы - адаптивные
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Статистика',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 1000) {
                      // Большие экраны - горизонтально
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChart(
                            title: 'ГФУ (R134a, R123, R143a)',
                            data: const {
                              '1,1,1,2‑тетрафторэтан (R134a)': 30,
                              '1,1,1‑трифтор‑2,2‑дихлорэтан (R123)': 20,
                              '1,1,1‑Трифторэтан (R143a)': 25,
                            },
                          ),
                          const SizedBox(width: 24),
                          _buildChart(
                            title: 'ХФУ (R113, R141b, R114b2)',
                            data: const {
                              '1,1,2‑трифтор‑1,2,2‑трихлорэтан (R113)': 35,
                              '1,1‑дихлор‑1‑фторэтан (R141b)': 25,
                              '1,2‑Дибром‑1,1,2,2‑тетрафторэтан (R114b2)': 15,
                            },
                          ),
                         
                        ],
                      );
                    } else if (constraints.maxWidth > 600) {
                      // Средние экраны - 2x2 сетка
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildChart(
                                title: 'ГФУ (R134a, R123, R143a)',
                                data: const {
                                  '1,1,1,2‑тетрафторэтан (R134a)': 30,
                                  '1,1,1‑трифтор‑2,2‑дихлорэтан (R123)': 20,
                                  '1,1,1‑Трифторэтан (R143a)': 25,
                                },
                              ),
                              const SizedBox(width: 24),
                              _buildChart(
                                title: 'ХФУ (R113, R141b, R114b2)',
                                data: const {
                                  '1,1,2‑трифтор‑1,2,2‑трихлорэтан (R113)': 35,
                                  '1,1‑дихлор‑1‑фторэтан (R141b)': 25,
                                  '1,2‑Дибром‑1,1,2,2‑тетрафторэтан (R114b2)': 15,
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildChart(
                            title: 'Прочие',
                            data: const {
                              '1,2‑Дихлорэтан': 40,
                            },
                          ),
                        ],
                      );
                    } else {
                      // Маленькие экраны - вертикально
                      return Column(
                        children: [
                          _buildChart(
                            title: 'ГФУ (R134a, R123, R143a)',
                            data: const {
                              '1,1,1,2‑тетрафторэтан (R134a)': 30,
                              '1,1,1‑трифтор‑2,2‑дихлорэтан (R123)': 20,
                              '1,1,1‑Трифторэтан (R143a)': 25,
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildChart(
                            title: 'ХФУ (R113, R141b, R114b2)',
                            data: const {
                              '1,1,2‑трифтор‑1,2,2‑трихлорэтан (R113)': 35,
                              '1,1‑дихлор‑1‑фторэтан (R141b)': 25,
                              '1,2‑Дибром‑1,1,2,2‑тетрафторэтан (R114b2)': 15,
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildChart(
                            title: 'Прочие',
                            data: const {
                              '1,2‑Дихлорэтан': 40,
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Бесплатные документы
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '30 дней бесплатного тестирования\nдля всех новых клиентов',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
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
                  child: const Text('Начать тестирование'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart({required String title, required Map<String, double> data}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивные размеры и отступы
        double containerPadding = 24;
        double chartSize = 220;
        
        if (constraints.maxWidth < 400) {
          containerPadding = 16;
          chartSize = 180;
        } else if (constraints.maxWidth < 600) {
          containerPadding = 20;
          chartSize = 200;
        } else if (constraints.maxWidth < 800) {
          containerPadding = 22;
          chartSize = 210;
        } else {
          containerPadding = 24;
          chartSize = 220;
        }

        return Container(
          padding: EdgeInsets.all(containerPadding),
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
          child: SimplePieChart(
            data: data,
            size: chartSize,
            title: title,
            isResponsive: true,
          ),
        );
      },
    );
  }

  Widget _buildBenefitCard(IconData icon, String text) {
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
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
