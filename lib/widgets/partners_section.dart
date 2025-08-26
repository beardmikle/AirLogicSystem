import 'package:flutter/material.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 768;
        final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1200;
        final isDesktop = MediaQuery.of(context).size.width >= 1200;
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : isTablet ? 24.0 : 32.0,
            vertical: isMobile ? 40.0 : isTablet ? 60.0 : 80.0,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
          ),
          child: Column(
            children: [
              Text(
                'Надежная и безопасная\nсистема управления',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 24 : isTablet ? 30 : 36,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                  height: 1.2,
                ),
              ),
              SizedBox(height: isMobile ? 40 : isTablet ? 60 : 80),
              
              // Преимущества безопасности
              if (isMobile)
                _buildMobileSecurityCards()
              else if (isTablet)
                _buildTabletSecurityCards()
              else
                _buildDesktopSecurityCards(),
              
              SizedBox(height: isMobile ? 40 : isTablet ? 60 : 80),
              
              // Роуминг с операторами
              Container(
                padding: EdgeInsets.all(isMobile ? 24 : isTablet ? 36 : 48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Совместимость с популярными газоанализаторами',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 20 : isTablet ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Поддержка всех основных производителей оборудования',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Список совместимого оборудования',
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              color: const Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: isMobile ? 40 : isTablet ? 60 : 80),
              
              // Поиск контрагентов
              Container(
                padding: EdgeInsets.all(isMobile ? 24 : isTablet ? 36 : 48),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Более 1000 предприятий уже используют AirLogicSystem для управления газоанализаторами',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : isTablet ? 22 : 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 24 : 32,
                          vertical: isMobile ? 14 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Найти клиентов'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileSecurityCards() {
    return Column(
      children: [
        _buildSecurityCard(
          Icons.cloud_done,
          'Облачное хранение данных с резервным копированием на нескольких серверах',
        ),
        const SizedBox(height: 16),
        _buildSecurityCard(
          Icons.support_agent,
          'Техническая поддержка 24/7 через чат, email и телефон. Быстрое решение проблем',
        ),
        const SizedBox(height: 16),
        _buildSecurityCard(
          Icons.people,
          'Неограниченное количество пользователей для каждой организации',
        ),
        const SizedBox(height: 16),
        _buildSecurityCard(
          Icons.shield,
          'Многоуровневая защита данных с шифрованием и сертификатами безопасности',
        ),
      ],
    );
  }

  Widget _buildTabletSecurityCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSecurityCard(
                Icons.cloud_done,
                'Облачное хранение данных с резервным копированием на нескольких серверах',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSecurityCard(
                Icons.support_agent,
                'Техническая поддержка 24/7 через чат, email и телефон. Быстрое решение проблем',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecurityCard(
                Icons.people,
                'Неограниченное количество пользователей для каждой организации',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSecurityCard(
                Icons.shield,
                'Многоуровневая защита данных с шифрованием и сертификатами безопасности',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopSecurityCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSecurityCard(
            Icons.cloud_done,
            'Облачное хранение данных с резервным копированием на нескольких серверах',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildSecurityCard(
            Icons.support_agent,
            'Техническая поддержка 24/7 через чат, email и телефон. Быстрое решение проблем',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildSecurityCard(
            Icons.people,
            'Неограниченное количество пользователей для каждой организации',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildSecurityCard(
            Icons.shield,
            'Многоуровневая защита данных с шифрованием и сертификатами безопасности',
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityCard(IconData icon, String text) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 768;
        final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1200;
        
        return Container(
          padding: EdgeInsets.all(isMobile ? 20 : isTablet ? 24 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: isMobile ? 60 : isTablet ? 70 : 80,
                height: isMobile ? 60 : isTablet ? 70 : 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(isMobile ? 15 : isTablet ? 18 : 20),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1976D2),
                  size: isMobile ? 30 : isTablet ? 35 : 40,
                ),
              ),
              SizedBox(height: isMobile ? 16 : isTablet ? 20 : 24),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : isTablet ? 15 : 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
