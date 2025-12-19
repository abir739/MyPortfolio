import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with SingleTickerProviderStateMixin {
  bool isFrench = false;
  bool isDarkMode = false;
  final String githubUrl = 'https://github.com/abir739';
  final String linkedinUrl =
      'https://www.linkedin.com/in/abir-cherif-931770202/';
  final String cvEnglishUrl =
      'https://abir739.github.io/MyPortfolio/assets/pdf/Abir Cherif CV.pdf';
  final String cvFrenchUrl =
      'https://abir739.github.io/MyPortfolio/assets/pdf/Abir Cherif CV_fr.pdf';
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fabAnimationController;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 300 && !_showFab) {
      setState(() => _showFab = true);
      _fabAnimationController.forward();
    } else if (_scrollController.offset <= 300 && _showFab) {
      setState(() => _showFab = false);
      _fabAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
        await launchUrl(uri);
      }
    }
  }

  void _toggleLanguage() {
    setState(() => isFrench = !isFrench);
  }

  void _toggleDarkMode() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void _downloadCV() {
    _launchUrl(isFrench ? cvFrenchUrl : cvEnglishUrl);
  }

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Color get _primaryColor =>
      isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700;
  Color get _backgroundColor =>
      isDarkMode ? const Color(0xFF0A0E27) : Colors.white;
  Color get _cardColor => isDarkMode ? const Color(0xFF1A1F3A) : Colors.white;
  Color get _textColor => isDarkMode ? Colors.white : Colors.grey.shade900;
  Color get _subtextColor =>
      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 900;

    return Theme(
      data: isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: _backgroundColor,
              cardColor: _cardColor,
              primaryColor: _primaryColor,
              iconTheme: IconThemeData(color: _textColor),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: _backgroundColor,
              cardColor: _cardColor,
              primaryColor: _primaryColor,
              iconTheme: IconThemeData(color: _textColor),
            ),
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              pinned: true,
              elevation: 0,
              backgroundColor: isDarkMode
                  ? Colors.blue.shade900.withOpacity(0.9)
                  : Colors.blue.shade700.withOpacity(0.95),
              flexibleSpace: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade700.withOpacity(0.95),
                        Colors.blue.shade900.withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Text(
                'Abir Cherif',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFrench ? Icons.language : Icons.translate,
                    color: Colors.white,
                  ),
                  onPressed: _toggleLanguage,
                  tooltip: isFrench ? 'English' : 'Français',
                ),
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  onPressed: _toggleDarkMode,
                  tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  onPressed: _downloadCV,
                  tooltip: isFrench ? 'Télécharger CV' : 'Download CV',
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeroSection(isMobile),
                  // _buildQuickStats(),
                  _buildAboutSection(),
                  _buildExperienceSection(),
                  _buildProjectsSection(),
                  _buildSkillsSection(isMobile),
                  _buildEducationSection(),
                  _buildContactSection(isMobile),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(),
        floatingActionButton: _showFab
            ? ScaleTransition(
                scale: _fabAnimationController,
                child: FloatingActionButton(
                  onPressed: () => _scrollToSection(0),
                  backgroundColor: _primaryColor,
                  child: const Icon(Icons.arrow_upward),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF0A0E27), const Color(0xFF1A1F3A)]
                : [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/img.jpg'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Abir Cherif',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Flutter Developer',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', 0),
            _buildDrawerItem(Icons.account_circle, 'About', 600),
            _buildDrawerItem(Icons.work, 'Experience', 1200),
            _buildDrawerItem(Icons.code, 'Projects', 2000),
            _buildDrawerItem(Icons.star, 'Skills', 3000),
            _buildDrawerItem(Icons.school, 'Education', 3600),
            _buildDrawerItem(Icons.contact_mail, 'Contact', 4200),
            const Divider(),
            ListTile(
              leading: Icon(Icons.email, color: _primaryColor),
              title: Text(
                'Email Me',
                style: GoogleFonts.poppins(color: _textColor),
              ),
              onTap: () => _launchUrl('mailto:abircherif212@gmail.com'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, double scrollPosition) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(title, style: GoogleFonts.poppins(color: _textColor)),
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(scrollPosition);
      },
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF0F2027),
                  const Color(0xFF203A43),
                  const Color(0xFF2C5364),
                ]
              : [
                  Colors.blue.shade600,
                  Colors.blue.shade800,
                  Colors.blue.shade900,
                ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24.0 : 48.0,
          vertical: isMobile ? 60.0 : 100.0,
        ),
        child: Column(
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade300.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: isMobile ? 80 : 100,
                      backgroundImage: const AssetImage(
                        'assets/images/img.jpg',
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 900),
              child: Column(
                children: [
                  Text(
                    'Abir Cherif',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isMobile ? 36 : 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Text(
                      isFrench
                          ? 'Développeuse Mobile Flutter'
                          : 'Flutter Mobile Developer',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Monastir, Tunisia',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildActionButton(
                        Icons.visibility,
                        isFrench ? 'Voir CV' : 'View CV',
                        () => _launchUrl(isFrench ? cvFrenchUrl : cvEnglishUrl),
                        isPrimary: true,
                      ),
                      _buildActionButton(
                        Icons.download,
                        isFrench ? 'Télécharger' : 'Download',
                        _downloadCV,
                        isPrimary: false,
                      ),
                      _buildActionButton(
                        Icons.email,
                        'Contact',
                        () => _launchUrl('mailto:abircherif212@gmail.com'),
                        isPrimary: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        Icons.code,
                        () => _launchUrl(githubUrl),
                        'GitHub',
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        Icons.work,
                        () => _launchUrl(linkedinUrl),
                        'LinkedIn',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.apps, color: _primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  isFrench ? 'Applications Publiées' : 'Released Apps',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 600;
                  return isCompact
                      ? Column(
                          children: [
                            _buildCompactReleasedApp(
                              title: 'Sunshine Vacances',
                              appStoreUrl:
                                  'https://apps.apple.com/fr/developer/continuousnet/id1772875128',
                              playStoreUrl:
                                  'https://play.google.com/store/apps/details?id=com.zenify_client_app',
                              image: 'assets/images/sunshine.png',
                            ),
                            const SizedBox(height: 16),
                            _buildCompactReleasedApp(
                              title: 'ZenifyTrip',
                              playStoreUrl: 'https://zenifytrip.com/',
                              image: 'assets/images/zenify_trip.png',
                            ),
                            const SizedBox(height: 16),
                            _buildCompactReleasedApp(
                              title: 'Tunisie Promo',
                              playStoreUrl: 'https://www.tunisiepromo.tn/',
                              image: 'assets/images/tunisie_promo.png',
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildCompactReleasedApp(
                                title: 'Sunshine Vacances',
                                playStoreUrl:
                                    'https://play.google.com/store/apps/details?id=com.zenify_client_app',
                                image: 'assets/images/sunshine.png',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildCompactReleasedApp(
                                title: 'ZenifyTrip',
                                playStoreUrl: 'https://zenifytrip.com/',
                                image: 'assets/images/zenify_trip.png',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildCompactReleasedApp(
                                title: 'Tunisie Promo',
                                playStoreUrl: 'https://www.tunisiepromo.tn/',
                                image: 'assets/images/tunisie_promo.png',
                              ),
                            ),
                          ],
                        );
                },
              ),
            ),
            const SizedBox(height: 40),
            Text(
              isFrench ? 'Projets Personnels' : 'Personal Projects',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Instagram Clone',
              description:
                  'Clone Instagram avec authentification Firebase, feed et chat.',
              githubUrl: 'https://github.com/abir739/Instagram-Clone',
              imagePath: 'assets/images/instagram_clone.png',
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Voyageur App',
              description:
                  'A travel app for managing accommodations and transfers with real-time data and Firebase integration.',
              githubUrl: 'https://github.com/abir739/Voyageur_app',
              imagePath: 'assets/images/voyageur.png',
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Habit Tracker',
              description:
                  'A Flutter app for tracking daily habits with Provider state management and local storage.',
              githubUrl: 'https://github.com/abir739/Habit-Tracker-Flutter-app',
              imagePath: 'assets/images/habit_tracker.png',
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Guide App',
              description:
                  'A tourist guide app with user profiles, notifications, and offline support.',
              githubUrl: 'https://github.com/abir739/Guide_app',
              imagePath: 'assets/images/guide_app.png',
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Quiz App',
              description:
                  'A cross-platform quiz app with local storage, scoring, and dynamic question loading.',
              githubUrl: 'https://github.com/abir739/Quiz_App',
              imagePath: 'assets/images/quiz_app.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactReleasedApp({
    required String title,
    required String playStoreUrl,
    String? appStoreUrl,
    String? image,
  }) {
    return Card(
      elevation: isDarkMode ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null)
            SizedBox(height: 120, child: Image.asset(image, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(playStoreUrl),
                  icon: const Icon(Icons.android, size: 16),
                  label: const Text(
                    'Play Store',
                    style: TextStyle(fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                if (appStoreUrl != null) ...[
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _launchUrl(appStoreUrl),
                    icon: const Icon(Icons.phone_iphone, size: 16),
                    label: const Text(
                      'App Store',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalProjectCard({
    required String title,
    required String description,
    required String githubUrl,
    String? imagePath,
    List<String>? technologies = const [],
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 8,
        shadowColor: Colors.blue.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: MediaQuery.of(context).size.width < 800
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _projectCardChildren(
                    title: title,
                    description: description,
                    githubUrl: githubUrl,
                    imagePath: imagePath,
                    technologies: technologies,
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imagePath,
                          width: 280,
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imagePath != null) const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _projectCardChildren(
                          title: title,
                          description: description,
                          githubUrl: githubUrl,
                          imagePath: null,
                          technologies: technologies,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _projectCardChildren({
    required String title,
    required String description,
    required String githubUrl,
    String? imagePath,
    List<String>? technologies,
  }) {
    return [
      if (imagePath != null) ...[
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        description,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey.shade700,
          height: 1.6,
        ),
      ),
      if (technologies != null && technologies.isNotEmpty) ...[
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: technologies
              .map(
                (tech) => Chip(
                  label: Text(
                    tech,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
              .toList(),
        ),
      ],
      const SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: () => _launchUrl(githubUrl),
        icon: const Icon(Icons.code, size: 18),
        label: Text(
          'View on GitHub',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
    ];
  }

  Widget _buildSkillsSection(bool isMobile) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.star, color: _primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  isFrench ? 'Compétences' : 'Skills',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSkillCategory('Programming Languages', [
              'Dart',
              'JavaScript',
              'Java',
              'Kotlin',
              'Swift',
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Frameworks & SDKs', [
              'Flutter',
              'Firebase (Auth, Firestore, FCM, Storage)',
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('State Management', [
              'BLoC',
              'GetX',
              'Riverpod',
              'Provider',
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Tools & DevOps', [
              'GoRouter',
              'GetIt',
              'GitLab CI/CD',
              'Fastlane',
              'Hive',
              'Dio',
              'Retrofit',
              'Xcode',
              'Postman',
              'Swagger UI',
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Methodologies', [
              'RESTful APIs',
              'WebSockets',
              'MVVM',
              'Clean Architecture',
              'Atomic Design',
              'Agile/Scrum',
              'UI/UX',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String category, List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills
              .map(
                (skill) => Chip(
                  label: Text(
                    skill,
                    style: GoogleFonts.poppins(fontSize: 14, color: _textColor),
                  ),
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.school, color: _primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  isFrench ? 'Formation' : 'Education',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildEducationCard(
              title: isFrench
                  ? 'Diplôme National d’Ingénieur en Informatique (Niveau 7 CEC)'
                  : 'Engineering Degree in Computer Science (EQF Level 7)',
              school:
                  'École Nationale des Sciences de l\'Informatique - ENSI, Tunisia',
              duration: '09/2020 - 07/2023',
            ),
            const SizedBox(height: 16),
            _buildEducationCard(
              title: isFrench
                  ? 'Licence en Mathématiques et Applications'
                  : 'Bachelor’s Degree in Mathematics and Applications',
              school:
                  'Institut Supérieur d\'Informatique et de Mathématiques - ISIMM, Tunisia',
              duration: '09/2017 - 07/2020',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard({
    required String title,
    required String school,
    required String duration,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [/* same */],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            school,
            style: GoogleFonts.poppins(fontSize: 15, color: _subtextColor),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: _subtextColor),
              const SizedBox(width: 8),
              Text(
                duration,
                style: GoogleFonts.poppins(fontSize: 14, color: _subtextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF0F2027), const Color(0xFF203A43)]
              : [Colors.blue.shade700, Colors.blue.shade900],
        ),
      ),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          children: [
            Text(
              isFrench ? 'Contactez-moi' : 'Get in Touch',
              style: GoogleFonts.playfairDisplay(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFrench
                  ? 'Disponible pour des opportunités Flutter / Mobile'
                  : 'Available for Flutter / Mobile opportunities',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  Icons.email,
                  'Email Me',
                  () => _launchUrl('mailto:abircherif212@gmail.com'),
                  isPrimary: true,
                ),
                _buildActionButton(
                  Icons.code,
                  'GitHub',
                  () => _launchUrl(githubUrl),
                  isPrimary: false,
                ),
                _buildActionButton(
                  Icons.link,
                  'LinkedIn',
                  () => _launchUrl(linkedinUrl),
                  isPrimary: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: isDarkMode ? const Color(0xFF0A0E27) : Colors.grey.shade100,
      child: Text(
        '© 2025 Abir Cherif. All rights reserved.',
        style: GoogleFonts.poppins(fontSize: 14, color: _subtextColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ElasticIn(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Colors.white
              : Colors.white.withOpacity(0.2),
          foregroundColor: isPrimary ? Colors.blue.shade900 : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: isPrimary
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          elevation: isPrimary ? 5 : 0,
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    VoidCallback onPressed,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_circle,
                    color: _primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isFrench ? 'À Propos' : 'About Me',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              isFrench
                  ? 'Développeuse Flutter passionnée, spécialisée dans les applications mobiles multiplateformes performantes, basées sur MVVM et Clean Architecture. Expérience confirmée dans la publication et la maintenance d’applications en production sur le Google Play Store et l’App Store.'
                  : 'Passionate Flutter Developer specializing in high-performance cross-platform mobile applications using MVVM and CleanArchitecture. I\'ve published and maintained 3 production apps on Google Play and App Store.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: _subtextColor,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildHighlightChip('MVVM & Clean Architecture'),
                _buildHighlightChip('Google Play Store, App Store'),
                _buildHighlightChip('CI/CD Pipelines'),
                _buildHighlightChip('BLoC, GetX, Riverpod'),
                _buildHighlightChip('Atomic Design,  GoRouter (Navigator 2.0)'),
                _buildHighlightChip('Firebase Expert'),
                _buildHighlightChip('Agile/Scrum'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryColor.withOpacity(0.1),
            _primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: _primaryColor, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.work, color: _primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  isFrench ? 'Expérience' : 'Experience',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildExperienceCard(
              isFrench ? 'Développeuse Mobile' : 'Mobile Developer',
              'Continuous Net',
              isFrench ? 'Juil 2023 - Présent' : 'Jul 2023 - Present',
              [
                isFrench
                    ? '3 applications Flutter publiées sur Play Store et App Store'
                    : 'Published 3 Flutter apps on Play Store and App Store',
                isFrench
                    ? 'Conception d’applications multiplateformes basées sur MVVM, Clean Architecture et Atomic Design, garantissant des bases de code évolutives et maintenables.'
                    : 'Architected large-scale cross-platform applications using MVVM, Clean Architecture, and Atomic Design, ensuring scalable and maintainable codebases.',
                isFrench
                    ? 'Mise en place de builds multi-environnements (dev, staging, prod) pour les tests parallèles, l’optimisation du CI/CD et des déploiements sécurisés.'
                    : 'Implemented multi-flavor builds (dev, staging, prod) to support parallel testing, saferreleases, and streamlined CI/CD pipelines.',
                isFrench
                    ? 'Implémentation de fonctionnalités temps réel : découverte d’activités, achats intégrés, chat WebSocket, notifications FCM, avec navigation avancée via GoRouter (Navigator 2.0) (deep linking, routes imbriquées, guards, redirections).'
                    : 'Built real-time features such as activity discovery, in-app purchases, WebSocket chat, FCM notifications, and optimized networking with Dio/Retrofit.',
                isFrench
                    ? 'Conception de packages Flutter réutilisables et d’un Design System partagé, intégrés viapub/path dependencies, réduisant le temps de développement de 40 % sur les projets white-label.'
                    : 'Designed and maintained reusable Flutter packages and shared design systems, enabling code sharing across white-label apps and reducing development time by 40%',
                isFrench
                    ? 'Gestion d’état et de routing complexes avec Riverpod, GetX, GetIt et Provider, optimisation réseau avec Dio/Retrofit, atteignant 80 % de couverture de tests via GitLab CI/CD et Rédaction d’une documentation technique claire pour faciliter l’onboarding. '
                    : ' Implemented advanced state management and routing using Riverpod, BLoC, GetX, GetIt, and GoRouter (Navigator 2.0) with deep linking, guards, and nested routes, achieving 80% test coverage via GitLab CI/CD.',
              ],
              true,
            ),
            const SizedBox(height: 16),
            _buildExperienceCard(
              isFrench
                  ? 'Développeuse Mobile (Stage)'
                  : 'Mobile Developer (Intern)',
              'Continuous Net',
              isFrench ? 'Fév 2023 - Juin 2023' : 'Feb 2023 - Jun 2023',
              [
                isFrench
                    ? 'Conception et développement d\'une application de réservation de voyages en Flutter, avec authentification multiplateforme (Facebook, Instagram, Apple Sign-In) et une expérience utilisateur améliorée.'
                    : 'Design and development of a Flutter travel booking application, with multi-platform authentication (Facebook, Instagram, Apple Sign-In) and improved user experience.',
                isFrench
                    ? 'Collaboration étroite avec l’équipe backend sur la conception et l’intégration d’API RESTful, améliorant le taux de réservation de 30 % grâce à l’optimisation de l’expérience utilisateur.'
                    : 'Close collaboration with the backend team on the design and integration of RESTful APIs, improving the booking completion rate by 30% through user experience optimization.',
              ],
              false,
            ),
            const SizedBox(height: 16),
            _buildExperienceCard(
              isFrench ? 'Développeuse Web (Stage)' : 'Web Developer (Intern)',
              isFrench ? 'Groupe DRÄXLMAIER' : 'DRÄXLMAIER Group',
              isFrench ? 'Juin 2022 - Aout 2022' : 'June 2022 - Aug 2022',
              [
                isFrench
                    ? 'Intégration et développement d’une application web d’archivage numérique en PHP/Laravel, avec une gestion multi-formats et des contrôles d’accès.'
                    : 'Integration and development of a PHP/Laravel web application for digital archiving withmulti-format support and access controls',
                isFrench
                    ? 'Optimisation des temps de chargement de 25 % et amélioration de l’interface en HTML5/CSS3/JavaScript lors de revues de code en entreprise.'
                    : 'Enhanced loading times by 25% and improved the interface usingHTML5/CSS3/Bootstrap/JavaScript during in-house code reviews.',
              ],
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(
    String title,
    String company,
    String duration,
    List<String> points,
    bool isCurrent,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? _primaryColor.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: _primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    isFrench ? 'Actuel' : 'Current',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: _subtextColor),
              const SizedBox(width: 8),
              Text(
                duration,
                style: GoogleFonts.poppins(fontSize: 13, color: _subtextColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _subtextColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
