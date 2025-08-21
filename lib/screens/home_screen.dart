import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/hero_section.dart';
import '../widgets/features_section.dart';
import '../widgets/benefits_section.dart';
import '../widgets/partners_section.dart';
import '../widgets/success_stories_section.dart';
import '../widgets/mobile_app_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/app_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            const HeroSection(),
            const FeaturesSection(),
            const BenefitsSection(),
            const PartnersSection(),
            const SuccessStoriesSection(),
            const MobileAppSection(),
            const ContactSection(),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
