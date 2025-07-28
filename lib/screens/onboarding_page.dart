import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pvit_gestion/screens/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<_OnboardingItem> items = [
    _OnboardingItem(
      imagePath: 'assets/img/image 1.png',
      title: 'Effectuer vos\nInstallations de TPE',
      subtitle:
          'Grâce à l’application, vous réalisez vos installations rapidement et renseignez toutes les informations nécessaires, étape par étape.',
    ),
    _OnboardingItem(
      imagePath: 'assets/img/image 1-1.png',
      title: 'Effectuer et recevoir\nVos missions',
      subtitle:
          'Vous êtes informé en temps réel dès qu’une mission vous est assignée. Vous pouvez consulter les détails et mettre à jour le statut de chaque intervention.',
    ),
    _OnboardingItem(
      imagePath: 'assets/img/image 1-2.png',
      title: 'Accéder à\nL’historique de toutes\nVos interventions',
      subtitle:
          'Retrouvez toutes vos interventions passées, avec les rapports, les photos et les dates, pour un meilleur suivi de vos activités.',
    ),
  ];

  void _nextPage() {
    if (currentIndex < items.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: items.length,
                    onPageChanged: (index) =>
                        setState(() => currentIndex = index),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50.h),
                            Image.asset(item.imagePath, height: 250.h),
                            SizedBox(height: 30.h),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1,
                                fontSize: 30.sp,
                                letterSpacing: -1.8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              item.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1,
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 16,
                      ),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index
                            ? Colors.blue
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.blue,
                        ),
                        child: Icon(
                          currentIndex == items.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bouton retour (flèche) si page > 0
            if (currentIndex > 0)
              Positioned(
                top: 16.h,
                left: 16.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),

            // Bouton Skip si pas dernière page
            if (currentIndex < items.length - 1)
              Positioned(
                top: 20.h,
                right: 20.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String imagePath;
  final String title;
  final String subtitle;

  _OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}
