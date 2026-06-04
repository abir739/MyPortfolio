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
  bool isDarkMode = true;
  final String githubUrl = 'https://github.com/abir739';
  final String linkedinUrl =
      'https://www.linkedin.com/in/abir-cherif-931770202/';
  final String cvEnglishUrl =
      'https://abir739.github.io/MyPortfolio/assets/assets/pdf/Abir-Cherif-Mobile-Engineer.pdf';
  final String cvFrenchUrl =
      'https://abir739.github.io/MyPortfolio/assets/assets/pdf/Abir_Cherif_Développeuse_Mobile.pdf';
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fabAnimationController;
  bool _showFab = false;

  // Color system — Purple/Violet + Sky Blue accent
  Color get _primaryColor =>
      isDarkMode ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
  Color get _accentColor =>
      isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
  Color get _backgroundColor =>
      isDarkMode ? const Color(0xFF0D0B1A) : const Color(0xFFFAFAFF);
  Color get _cardColor => isDarkMode ? const Color(0xFF1E1A3A) : Colors.white;
  Color get _textColor =>
      isDarkMode ? const Color(0xFFF1F0FF) : const Color(0xFF1E1B4B);
  Color get _subtextColor =>
      isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _borderColor =>
      isDarkMode ? const Color(0xFF2D2750) : const Color(0xFFE9D5FF);

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
    try {
      if (kIsWeb && url.startsWith('mailto:')) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_self',
        );
      } else if (kIsWeb) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );
      } else {
        final canLaunch = await canLaunchUrl(uri);
        if (!canLaunch) throw 'Cannot launch this URL';
        LaunchMode mode;
        if (url.startsWith('mailto:') ||
            url.startsWith('tel:') ||
            url.startsWith('sms:')) {
          mode = LaunchMode.platformDefault;
        } else {
          mode = LaunchMode.externalApplication;
        }
        await launchUrl(uri, mode: mode);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFrench ? 'Impossible d\'ouvrir le lien' : 'Could not open link',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (kDebugMode) print('Error launching URL: $e');
    }
  }

  void _toggleLanguage() => setState(() => isFrench = !isFrench);
  void _toggleDarkMode() => setState(() => isDarkMode = !isDarkMode);
  void _downloadCV() => _launchUrl(isFrench ? cvFrenchUrl : cvEnglishUrl);

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
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
        backgroundColor: _backgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeroSection(isMobile),
                  // _buildStatsSection(isMobile),
                  _buildAboutSection(),
                  _buildWhatIDoSection(isMobile),
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
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.arrow_upward),
                ),
              )
            : null,
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      snap: true,
      pinned: true,
      elevation: 0,
      backgroundColor: isDarkMode
          ? const Color(0xFF0D0B1A).withOpacity(0.95)
          : const Color(0xFF6D28D9).withOpacity(0.97),
      flexibleSpace: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [const Color(0xFF1A1033), const Color(0xFF0D0B1A)]
                  : [const Color(0xFF7C3AED), const Color(0xFF4F46E5)],
            ),
            border: Border(
              bottom: BorderSide(
                color: _primaryColor.withOpacity(0.3),
                width: 1,
              ),
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
      title: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Abir Cherif',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
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
                ? [const Color(0xFF0D0B1A), const Color(0xFF1E1A3A)]
                : [const Color(0xFFF5F3FF), Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [const Color(0xFF4C1D95), const Color(0xFF1E1A3A)]
                      : [const Color(0xFF7C3AED), const Color(0xFF4F46E5)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _accentColor, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/images/img.jpg'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Abir Cherif',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isFrench
                        ? 'Ingénieure Mobile | Flutter & Android'
                        : 'Mobile Engineer | Flutter & Android',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, isFrench ? 'Accueil' : 'Home', 0),
            _buildDrawerItem(
              Icons.person,
              isFrench ? 'À Propos' : 'About',
              700,
            ),
            _buildDrawerItem(
              Icons.work,
              isFrench ? 'Expérience' : 'Experience',
              1400,
            ),
            _buildDrawerItem(
              Icons.apps,
              isFrench ? 'Projets' : 'Projects',
              2800,
            ),
            _buildDrawerItem(
              Icons.star,
              isFrench ? 'Compétences' : 'Skills',
              4200,
            ),
            _buildDrawerItem(
              Icons.school,
              isFrench ? 'Formation' : 'Education',
              4900,
            ),
            _buildDrawerItem(Icons.contact_mail, 'Contact', 5500),
            const Divider(height: 32),
            ListTile(
              leading: Icon(Icons.email, color: _primaryColor),
              title: Text(
                'abircherif212@gmail.com',
                style: GoogleFonts.poppins(color: _subtextColor, fontSize: 12),
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
      title: Text(
        title,
        style: GoogleFonts.poppins(color: _textColor, fontSize: 15),
      ),
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(scrollPosition);
      },
    );
  }

  // ─── HERO ────────────────────────────────────────────────────────────────

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF0D0B1A),
                  const Color(0xFF1A0F2E),
                  const Color(0xFF0F172A),
                ]
              : [
                  const Color(0xFF5B21B6),
                  const Color(0xFF4F46E5),
                  const Color(0xFF0284C7),
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryColor.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentColor.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24.0 : 80.0,
              vertical: isMobile ? 60.0 : 100.0,
            ),
            child: isMobile
                ? Column(
                    children: [
                      _buildHeroAvatar(isMobile),
                      const SizedBox(height: 32),
                      ..._buildHeroTextContent(isMobile),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildHeroTextContent(isMobile),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(child: _buildHeroAvatar(isMobile)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAvatar(bool isMobile) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: isMobile ? 190 : 230,
            height: isMobile ? 190 : 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_primaryColor.withOpacity(0.25), Colors.transparent],
              ),
            ),
          ),
          Container(
            width: isMobile ? 172 : 212,
            height: isMobile ? 172 : 212,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _accentColor.withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
          CircleAvatar(
            radius: isMobile ? 80 : 100,
            backgroundImage: const AssetImage('assets/images/img.jpg'),
            backgroundColor: _cardColor,
          ),
          Positioned(
            bottom: isMobile ? 10 : 16,
            right: isMobile ? 10 : 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green.shade500,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isFrench ? 'Disponible' : 'Available',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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

  List<Widget> _buildHeroTextContent(bool isMobile) {
    return [
      FadeInUp(
        duration: const Duration(milliseconds: 700),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accentColor.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_android, color: _accentColor, size: 14),
              const SizedBox(width: 6),
              Text(
                isFrench
                    ? 'Ingénieure Mobile · Flutter & Android Natif'
                    : 'Mobile Engineer · Flutter & Native Android',
                style: GoogleFonts.poppins(
                  color: _accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, _accentColor.withOpacity(0.85)],
          ).createShader(bounds),
          child: Text(
            'Abir Cherif',
            style: GoogleFonts.playfairDisplay(
              fontSize: isMobile ? 42 : 58,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
      ),
      const SizedBox(height: 14),
      FadeInUp(
        duration: const Duration(milliseconds: 900),
        child: Text(
          isFrench
              ? 'Spécialisée en Flutter, Android Natif (Kotlin + Jetpack Compose),\nCI/CD et architecture mobile scalable'
              : 'Specialized in Flutter & Native Android (Kotlin + Jetpack Compose),\nCI/CD automation & scalable mobile architecture',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 16,
            color: Colors.white.withOpacity(0.75),
            height: 1.7,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
      ),
      const SizedBox(height: 16),
      FadeInUp(
        duration: const Duration(milliseconds: 950),
        child: Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.white60,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              'Tunisia',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.business, color: Colors.white60, size: 15),
            const SizedBox(width: 5),
            Text(
              'Continuous Net',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white60),
            ),
          ],
        ),
      ),
      const SizedBox(height: 36),
      FadeInUp(
        duration: const Duration(milliseconds: 1000),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _heroPrimaryBtn(
              Icons.visibility,
              isFrench ? 'Voir CV' : 'View CV',
              () => _launchUrl(isFrench ? cvFrenchUrl : cvEnglishUrl),
            ),
            _heroOutlineBtn(
              Icons.download,
              isFrench ? 'Télécharger' : 'Download CV',
              _downloadCV,
            ),
            _heroOutlineBtn(
              Icons.email,
              'Contact',
              () => _launchUrl('mailto:abircherif212@gmail.com'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      FadeInUp(
        duration: const Duration(milliseconds: 1100),
        child: Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            _buildSocialButton(
              Icons.code,
              () => _launchUrl(githubUrl),
              'GitHub',
            ),
            const SizedBox(width: 12),
            _buildSocialButton(
              Icons.work,
              () => _launchUrl(linkedinUrl),
              'LinkedIn',
            ),
          ],
        ),
      ),
    ];
  }

  Widget _heroPrimaryBtn(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: _primaryColor.withOpacity(0.4),
      ),
    );
  }

  Widget _heroOutlineBtn(IconData icon, String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withOpacity(0.45), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  // ─── STATS ───────────────────────────────────────────────────────────────

  Widget _buildStatsSection(bool isMobile) {
    final stats = [
      {
        'value': '3',
        'label': isFrench ? 'Apps en Production' : 'Production Apps',
        'icon': Icons.phone_android,
      },
      {
        'value': '6+',
        'label': isFrench ? 'Packages Flutter' : 'Flutter Packages',
        'icon': Icons.extension_rounded,
      },
      {
        'value': '80%',
        'label': isFrench ? 'Couverture Tests' : 'Test Coverage',
        'icon': Icons.verified_rounded,
      },
      {
        'value': '40%',
        'label': isFrench ? 'Temps Dev Réduit' : 'Dev Time Saved',
        'icon': Icons.speed_rounded,
      },
    ];
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF130F26) : const Color(0xFF6D28D9),
          border: Border(
            bottom: BorderSide(color: _primaryColor.withOpacity(0.2)),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 24,
          runSpacing: 24,
          children: stats
              .map(
                (s) => _buildStatItem(
                  s['value'] as String,
                  s['label'] as String,
                  s['icon'] as IconData,
                  isMobile,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    bool isMobile,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ─── SECTION HEADER ──────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _primaryColor.withOpacity(0.2),
                _accentColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryColor, size: 22),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            Container(
              height: 3,
              width: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_primaryColor, _accentColor]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── ABOUT ───────────────────────────────────────────────────────────────

  Widget _buildAboutSection() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? _primaryColor.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.08),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              isFrench ? 'À Propos' : 'About Me',
              Icons.person,
            ),
            const SizedBox(height: 20),
            Text(
              isFrench
                  ? 'Ingénieure Mobile avec 3+ ans d\'expérience en production, spécialisée dans Flutter et Android natif (Kotlin + Jetpack Compose). Experte en Clean Architecture, gestion d\'état (Riverpod, Provider) et conception de SDK modulaires. Expérience confirmée dans les plateformes multi-flavors en marque blanche, l\'automatisation CI/CD et la gestion complète du cycle de publication sur l\'App Store et Google Play, au sein d\'environnements Agile/Scrum.'
                  : 'Mobile Engineer with 3+ years of production experience building scalable applications with Flutter and Native Android (Kotlin + Jetpack Compose). Skilled in Clean Architecture, state management (Riverpod, Provider), and modular SDK design. Proven track record in multi-flavor white-label platforms, CI/CD automation, and full release lifecycle ownership across App Store and Google Play, within Agile/Scrum environments.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: _subtextColor,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildHighlightChip('Flutter & Native Android'),
                _buildHighlightChip('Kotlin · Jetpack Compose'),
                _buildHighlightChip('MVVM & Clean Architecture'),
                _buildHighlightChip(
                  isFrench
                      ? 'Cycle de Release Complet'
                      : 'Full Release Lifecycle',
                ),
                _buildHighlightChip('CI/CD · GitLab · Fastlane'),
                _buildHighlightChip('Riverpod · GetX · Provider'),
                _buildHighlightChip('Coroutines · StateFlow'),
                _buildHighlightChip('White-label & SDK'),
                _buildHighlightChip('Firebase Expert'),
                _buildHighlightChip('Agile / Scrum'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryColor.withOpacity(0.1),
            _accentColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: _primaryColor, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── WHAT I DO ───────────────────────────────────────────────────────────

  Widget _buildWhatIDoSection(bool isMobile) {
    final specialties = [
      {
        'icon': Icons.phone_android,
        'title': isFrench ? 'Flutter & Android Natif' : 'Flutter & Native Android',
        'desc': isFrench
            ? 'Apps cross-platform avec Flutter et apps Android natives avec Kotlin + Jetpack Compose'
            : 'Cross-platform apps with Flutter and native Android apps with Kotlin + Jetpack Compose',
        'color': const Color(0xFF7C3AED),
      },
      {
        'icon': Icons.architecture_rounded,
        'title': isFrench ? 'Architecture' : 'App Architecture',
        'desc': isFrench
            ? 'MVVM, Clean Architecture, Design System et packages SDK modulaires réutilisables'
            : 'MVVM, Clean Architecture, Design System & modular SDK packages',
        'color': const Color(0xFF0EA5E9),
      },
      {
        'icon': Icons.rocket_launch_rounded,
        'title': 'CI/CD & DevOps',
        'desc': isFrench
            ? 'Pipelines GitLab/Fastlane, builds multi-flavor, tests automatisés et release stores'
            : 'GitLab/Fastlane pipelines, multi-flavor builds, automated testing & store releases',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.extension_rounded,
        'title': 'White-label & SDK',
        'desc': isFrench
            ? '6+ packages Flutter réutilisables réduisant le temps de développement de 40%'
            : '6+ reusable Flutter packages reducing development time by 40%',
        'color': const Color(0xFFF59E0B),
      },
    ];

    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              isFrench ? 'Ce Que Je Fais' : 'What I Do',
              Icons.lightbulb_rounded,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return isWide
                    ? Row(
                        children: specialties.asMap().entries.map((e) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: e.key < 3 ? 16 : 0,
                              ),
                              child: _buildSpecialtyCard(
                                e.value['icon'] as IconData,
                                e.value['title'] as String,
                                e.value['desc'] as String,
                                e.value['color'] as Color,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Column(
                        children: specialties
                            .map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildSpecialtyCard(
                                  s['icon'] as IconData,
                                  s['title'] as String,
                                  s['desc'] as String,
                                  s['color'] as Color,
                                ),
                              ),
                            )
                            .toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard(
    IconData icon,
    String title,
    String desc,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDarkMode ? 0.07 : 0.04),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: _subtextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── EXPERIENCE ──────────────────────────────────────────────────────────

  Widget _buildExperienceSection() {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              isFrench ? 'Expérience' : 'Experience',
              Icons.work,
            ),
            const SizedBox(height: 24),
            _buildTimelineCard(
              title: isFrench
                  ? 'Ingénieure Logiciel Mobile'
                  : 'Mobile Software Engineer',
              company: 'Continuous Net',
              duration: isFrench ? 'Juil 2023 – Présent' : 'Jul 2023 – Present',
              isCurrent: true,
              points: [
                isFrench
                    ? 'Responsable du développement mobile en tant qu\'ingénieure principale pour des applications en production (iOS & Android), avec gestion complète du cycle de vie : de l\'architecture jusqu\'à la publication sur les stores (Sunshine Vacances, ZenifyTrip, TunisiePromo).'
                    : 'Led mobile development as the primary mobile engineer for production apps (iOS & Android), owning the full lifecycle from architecture to store release (Sunshine Vacances, ZenifyTrip, TunisiePromo).',
                isFrench
                    ? 'Conception et livraison d\'une plateforme Flutter scalable multi-flavors (marque blanche) supportant 4 marques, avec configuration multi-tenant et un SDK modulaire (7+ packages internes), réduisant le temps de développement d\'environ 40%.'
                    : 'Architected and delivered a scalable multi-flavor (white-label) Flutter platform supporting 4 brands, with multi-tenant configuration and a modular SDK (7+ internal packages), reducing development time by ~40%.',
                isFrench
                    ? 'Mise en place d\'une Clean Architecture orientée fonctionnalités avec injection de dépendances, réduisant la dette technique et facilitant l\'intégration des nouveaux développeurs.'
                    : 'Designed and implemented a feature-driven Clean Architecture with dependency injection, reducing technical debt and accelerating onboarding for new developers.',
                isFrench
                    ? 'Développement de couches applicatives scalables utilisant des APIs REST (Dio), la navigation (GoRouter) et la gestion d\'état (Riverpod et Provider), incluant le caching (Hive), la communication en temps réel via WebSockets et l\'intégration de solutions de paiement sécurisées.'
                    : 'Built scalable application layers using REST APIs (Dio), navigation (GoRouter), and state management (Riverpod and Provider), including caching (Hive), real-time communication via WebSockets, and secure payment gateway integration.',
                isFrench
                    ? 'Intégration des services Firebase (Authentication, Cloud Messaging, App Distribution) et OneSignal pour les notifications push, avec prise en charge du multilingue (EN/FR/AR) et du RTL.'
                    : 'Integrated Firebase services (Authentication, Cloud Messaging, App Distribution) and OneSignal for push notifications, supporting multilingual apps (EN/FR/AR) with RTL.',
                isFrench
                    ? 'Conception et optimisation de pipelines CI/CD (GitLab, Fastlane) avec builds multi-flavors, et gestion complète du cycle de release : soumission aux stores, signature, conformité et documentation technique.'
                    : 'Designed and optimized CI/CD pipelines (GitLab, Fastlane) with multi-flavor builds, managing full release lifecycle: store submission, signing, compliance, and technical documentation.',
              ],
              technologies: [
                'Flutter',
                'Kotlin',
                'Riverpod',
                'Provider',
                'Clean Architecture',
                'GitLab CI/CD',
                'Fastlane',
                'Dio',
                'GoRouter',
                'Firebase',
                'OneSignal',
              ],
            ),
            _buildTimelineDivider(),
            _buildTimelineCard(
              title: isFrench
                  ? 'Développeuse Mobile (Stagiaire)'
                  : 'Mobile Developer (Intern)',
              company: 'Continuous Net',
              duration: isFrench
                  ? 'Fév 2023 – Juil 2023'
                  : 'Feb 2023 – Jul 2023',
              isCurrent: false,
              points: [
                isFrench
                    ? 'Développé une application de gestion de voyage double-rôle (voyageur & guide) avec authentification multi-fournisseurs (Google, Facebook, email)'
                    : 'Developed a dual-role travel app (traveler & tour guide) with multi-provider authentication (Google, Facebook, email) and Riverpod state management',
                isFrench
                    ? 'Conçu des interfaces responsives et adaptatives depuis des maquettes Figma, collaborant avec les équipes backend et UI/UX pour aligner les contrats API'
                    : 'Built responsive role-adaptive UIs from Figma designs, collaborating with backend & UX/UI teams to align API contracts across Android and iOS',
              ],
              technologies: [
                'Flutter',
                'Riverpod',
                'REST APIs',
                'Firebase',
                'Figma',
              ],
            ),
            _buildTimelineDivider(),
            _buildTimelineCard(
              title: isFrench
                  ? 'Développeuse Web (Stagiaire)'
                  : 'Web Developer (Intern)',
              company: isFrench ? 'Groupe DRÄXLMAIER' : 'DRÄXLMAIER Group',
              duration: isFrench
                  ? 'Juin 2022 – Aout 2022'
                  : 'Jun 2022 – Aug 2022',
              isCurrent: false,
              points: [
                isFrench
                    ? 'Développé un système d\'archivage de documents PHP/Laravel avec contrôle d\'accès basé sur les rôles pour 30+ utilisateurs internes'
                    : 'Built a PHP/Laravel document archiving system with role-based access control for 30+ internal users, supporting PDF, DOCX and image formats',
                isFrench
                    ? 'Optimisé les requêtes base de données et le rendu frontend, réduisant le temps de chargement de 25%'
                    : 'Optimized database queries and frontend rendering, reducing page load time by 25%',
              ],
              technologies: [
                'PHP',
                'Laravel',
                'MySQL',
                'HTML5',
                'CSS3',
                'Bootstrap',
              ],
            ),
            _buildTimelineDivider(),
            _buildTimelineCard(
              title: isFrench
                  ? 'Développeuse Mobile (Stagiaire)'
                  : 'Mobile Developer (Intern)',
              company: isFrench
                  ? 'ENSI · Services Municipaux'
                  : 'ENSI · Municipal Services App',
              duration: 'Oct 2021 – Mar 2022',
              isCurrent: false,
              points: [
                isFrench
                    ? 'Développé une application Flutter digitalisant les services municipaux (réservation de tickets, rendez-vous, chat WebSocket) avec Provider et Hive'
                    : 'Built a Flutter app digitalizing municipal services (ticket booking, appointments, WebSocket chat) with Provider and Hive for state management',
                isFrench
                    ? 'Intégré Google Maps, Firebase pour l\'authentification et un système basé sur les rôles (citoyens, employés, admins) avec signalement d\'incidents'
                    : 'Integrated Google Maps, Firebase authentication, and role-based system (citizens, employees, admins) with incident reporting and media uploads',
              ],
              technologies: [
                'Flutter',
                'Provider',
                'Hive',
                'Firebase',
                'Google Maps',
                'WebSocket',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 19, top: 6, bottom: 6),
      child: Container(
        width: 2,
        height: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(0.5),
              _primaryColor.withOpacity(0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineCard({
    required String title,
    required String company,
    required String duration,
    required bool isCurrent,
    required List<String> points,
    List<String> technologies = const [],
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCurrent
                      ? [_primaryColor, _accentColor]
                      : [
                          _primaryColor.withOpacity(0.4),
                          _primaryColor.withOpacity(0.2),
                        ],
                ),
                shape: BoxShape.circle,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                isCurrent ? Icons.work : Icons.history_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent
                    ? _primaryColor.withOpacity(0.4)
                    : _borderColor,
                width: isCurrent ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? (isCurrent
                            ? _primaryColor.withOpacity(0.07)
                            : Colors.black.withOpacity(0.2))
                      : Colors.grey.withOpacity(0.07),
                  blurRadius: 15,
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            company,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: _primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isFrench ? 'Actuel' : 'Current',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: _subtextColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      duration,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _subtextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            point,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: _subtextColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (technologies.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: technologies
                        .map(
                          (tech) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _accentColor.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: _accentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── PROJECTS ────────────────────────────────────────────────────────────

  Widget _buildProjectsSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              isFrench ? 'Projets & Applications' : 'Projects & Apps',
              Icons.apps,
            ),
            const SizedBox(height: 24),
            Text(
              isFrench ? 'Applications Publiées' : 'Production Apps',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 650;
                final sunshineCard = _buildReleasedAppCard(
                  title: 'Sunshine Vacances',
                  description: isFrench
                      ? 'Application de voyage et vacances avec réservation et gestion d\'itinéraires'
                      : 'Travel and vacation app with booking and itinerary management',
                  appStoreUrl:
                      'https://apps.apple.com/fr/developer/continuousnet/id1772875128',
                  playStoreUrl:
                      'https://play.google.com/store/apps/details?id=com.zenify_client_app',
                  websiteUrl: 'https://www.sunshinevacances.fr/',
                  image: 'assets/images/sunshine.png',
                  technologies: [
                    'Flutter',
                    'Riverpod',
                    'REST APIs',
                    'Firebase',
                  ],
                );
                final zenifyCard = _buildReleasedAppCard(
                  title: 'ZenifyTrip',
                  description: isFrench
                      ? 'Plateforme de voyage avec découverte d\'activités et paiements intégrés'
                      : 'Full travel platform with activity discovery and in-app payments',
                  websiteUrl: 'https://zenifytrip.com/',
                  image: 'assets/images/zenify_trip.png',
                  technologies: ['Flutter', 'GetX', 'WebSocket', 'Dio'],
                );
                final promoCard = _buildReleasedAppCard(
                  title: 'Tunisie Promo',
                  description: isFrench
                      ? 'Application de promotions et offres locales'
                      : 'Local promotions and deals app for Tunisian consumers',
                  appStoreUrl:
                      'https://apps.apple.com/us/app/tunisie-promo-deals-voyage/id6758765132',
                  playStoreUrl:
                      'https://play.google.com/store/apps/dev?id=7728432506457419444&hl=en',
                  websiteUrl: 'https://www.tunisiepromo.tn/',
                  image: 'assets/images/tunisie_promo.png',
                  technologies: ['Flutter', 'Provider', 'REST APIs'],
                );
                return isCompact
                    ? Column(
                        children: [
                          sunshineCard,
                          const SizedBox(height: 16),
                          zenifyCard,
                          const SizedBox(height: 16),
                          promoCard,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: sunshineCard),
                          const SizedBox(width: 16),
                          Expanded(child: zenifyCard),
                          const SizedBox(width: 16),
                          Expanded(child: promoCard),
                        ],
                      );
              },
            ),
            const SizedBox(height: 40),
            Text(
              isFrench ? 'Projets Personnels' : 'Personal Projects',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: isFrench
                  ? 'KotlinPosApp – Système POS Android Natif'
                  : 'KotlinPosApp – Native Android POS System',
              description: isFrench
                  ? 'Application POS Android complète avec scan de codes-barres en temps réel (CameraX + ML Kit), recherche automatique des produits via une chaîne de fallback sur 3 APIs, et stockage local offline-first avec Room. Architecture Clean Architecture + MVVM, Hilt pour l\'injection de dépendances et Jetpack Compose avec Material3.'
                  : 'Full-featured Android POS app with real-time barcode scanning (CameraX + ML Kit), automatic product lookup via a 3-API fallback chain, and offline-first local storage using Room. Architected with Clean Architecture and MVVM, using Hilt for DI, StateFlow for reactive UI, and Jetpack Compose with Material3.',
              githubUrl: 'https://github.com/abir739/kotlin-pos-app',
              imagePath: 'assets/images/kotlin-pos-app.png',
              technologies: [
                'Kotlin',
                'Jetpack Compose',
                'CameraX',
                'ML Kit',
                'Hilt',
                'Room',
                'Retrofit',
                'MVVM',
                'Clean Architecture',
              ],
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'ImageFlow – Smart Image Processing & OCR',
              description: isFrench
                  ? 'Application Flutter intelligente intégrant Google ML Kit pour la détection de visages avec filtrage N&B, la numérisation de documents avec OCR et export PDF.'
                  : 'Intelligent Flutter app integrating Google ML Kit for face detection with B&W filtering, document scanning with OCR text extraction, and PDF export.',
              githubUrl: 'https://github.com/abir739/imageflow_flutter',
              imagePath: 'assets/images/imageflow.png',
              technologies: [
                'Flutter',
                'ML Kit',
                'GetX',
                'OCR',
                'Clean Architecture',
              ],
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Instagram Clone',
              description: isFrench
                  ? 'Clone Instagram avec Flutter et Firebase : inscription, partage de photos/vidéos, likes, commentaires et abonnements.'
                  : 'Full Instagram clone with Flutter and Firebase: sign up, photo/video sharing, likes, comments, and follow system.',
              githubUrl: 'https://github.com/abir739/Instagram-Clone',
              imagePath: 'assets/images/instagram_clone.png',
              technologies: [
                'Flutter',
                'Firebase',
                'Firestore',
                'Storage',
                'GetX',
              ],
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Voyageur App',
              description: isFrench
                  ? 'Application de voyage pour la gestion d\'hébergements et de transferts avec données en temps réel et intégration Firebase.'
                  : 'Travel app for managing accommodations and transfers with real-time data and Firebase integration.',
              githubUrl: 'https://github.com/abir739/Voyageur_app',
              imagePath: 'assets/images/voyageur.png',
              technologies: ['Flutter', 'Firebase', 'Provider', 'REST APIs'],
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Habit Tracker',
              description: isFrench
                  ? 'Application Flutter de suivi des habitudes quotidiennes avec Provider et stockage local Hive.'
                  : 'Flutter app for tracking daily habits with Provider state management and Hive local storage.',
              githubUrl: 'https://github.com/abir739/Habit-Tracker-Flutter-app',
              imagePath: 'assets/images/habit_tracker.png',
              technologies: ['Flutter', 'Provider', 'Hive', 'Local Storage'],
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Guide App',
              description: isFrench
                  ? 'Application de guide touristique avec profils utilisateurs, notifications et support hors ligne.'
                  : 'Tourist guide app with user profiles, notifications, and offline support.',
              githubUrl: 'https://github.com/abir739/Guide_app',
              imagePath: 'assets/images/guide_app.png',
              technologies: ['Flutter', 'Firebase', 'Google Maps', 'GetX'],
            ),
            const SizedBox(height: 16),
            _buildPersonalProjectCard(
              title: 'Quiz App',
              description: isFrench
                  ? 'Application quiz cross-platform avec stockage local, système de score et chargement dynamique des questions.'
                  : 'Cross-platform quiz app with local storage, scoring system, and dynamic question loading.',
              githubUrl: 'https://github.com/abir739/Quiz_App',
              imagePath: 'assets/images/quiz_app.png',
              technologies: ['Flutter', 'Dart', 'Local Storage'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleasedAppCard({
    required String title,
    required String description,
    String? playStoreUrl,
    String? appStoreUrl,
    String? websiteUrl,
    String? image,
    List<String> technologies = const [],
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(isDarkMode ? 0.06 : 0.04),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null)
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isFrench ? 'Publié' : 'Live',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _subtextColor,
                    height: 1.4,
                  ),
                ),
                if (technologies.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: technologies
                        .map(
                          (tech) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: _primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (playStoreUrl != null)
                      _buildStoreButton(
                        Icons.android,
                        'Play Store',
                        playStoreUrl,
                        Colors.green.shade600,
                      ),
                    if (appStoreUrl != null)
                      _buildStoreButton(
                        Icons.phone_iphone,
                        'App Store',
                        appStoreUrl,
                        Colors.blueGrey.shade700,
                      ),
                    if (websiteUrl != null)
                      _buildStoreButton(
                        Icons.language_rounded,
                        isFrench ? 'Site Web' : 'Website',
                        websiteUrl,
                        _primaryColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreButton(
    IconData icon,
    String label,
    String url,
    Color color,
  ) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalProjectCard({
    required String title,
    required String description,
    required String githubUrl,
    String? imagePath,
    List<String> technologies = const [],
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? _primaryColor.withOpacity(0.04)
                  : Colors.grey.withOpacity(0.07),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: MediaQuery.of(context).size.width < 800
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imagePath != null)
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _projectCardContent(
                        title: title,
                        description: description,
                        githubUrl: githubUrl,
                        technologies: technologies,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imagePath != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Image.asset(
                        imagePath,
                        width: 260,
                        height: 260,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _projectCardContent(
                          title: title,
                          description: description,
                          githubUrl: githubUrl,
                          technologies: technologies,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _projectCardContent({
    required String title,
    required String description,
    required String githubUrl,
    List<String> technologies = const [],
  }) {
    return [
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        description,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: _subtextColor,
          height: 1.6,
        ),
      ),
      if (technologies.isNotEmpty) ...[
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: technologies
              .map(
                (tech) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _primaryColor.withOpacity(0.12),
                        _accentColor.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primaryColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    tech,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
      const SizedBox(height: 18),
      InkWell(
        onTap: () => _launchUrl(githubUrl),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_primaryColor, _accentColor]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.code, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                isFrench ? 'Voir sur GitHub' : 'View on GitHub',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // ─── SKILLS ──────────────────────────────────────────────────────────────

  Widget _buildSkillsSection(bool isMobile) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              isFrench ? 'Compétences' : 'Skills',
              Icons.star,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final col1 = [
                  _buildSkillCategoryCard(
                    isFrench ? 'Langages' : 'Languages',
                    Icons.code,
                    ['Dart', 'JavaScript', 'Kotlin', 'Swift'],
                    const Color(0xFF7C3AED),
                  ),
                  const SizedBox(height: 16),
                  _buildSkillCategoryCard(
                    isFrench ? 'Développement Mobile' : 'Mobile Dev',
                    Icons.phone_android,
                    ['Flutter', 'Kotlin', 'Jetpack Compose', 'Android SDK', 'Firebase', 'iOS'],
                    const Color(0xFF0EA5E9),
                  ),
                ];
                final col2 = [
                  _buildSkillCategoryCard(
                    isFrench ? 'Gestion d\'État' : 'State Management',
                    Icons.hub_rounded,
                    ['Riverpod', 'Provider', 'GetX', 'Coroutines', 'Flow/StateFlow'],
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 16),
                  _buildSkillCategoryCard('Networking', Icons.wifi_rounded, [
                    'REST APIs',
                    'GraphQL',
                    'Dio',
                    'Retrofit',
                    'WebSockets',
                  ], const Color(0xFFF59E0B)),
                ];
                final col3 = [
                  _buildSkillCategoryCard(
                    'CI/CD & Tools',
                    Icons.rocket_launch_rounded,
                    ['GitLab CI/CD', 'GitHub Actions', 'Fastlane', 'Xcode'],
                    const Color(0xFFEC4899),
                  ),
                  const SizedBox(height: 16),
                  _buildSkillCategoryCard(
                    isFrench ? 'Architecture' : 'Architecture & Design',
                    Icons.architecture_rounded,
                    [
                      'MVVM',
                      'Clean Architecture',
                      'Design System',
                      'Atomic Design',
                      'Agile/Scrum',
                    ],
                    const Color(0xFF6366F1),
                  ),
                ];
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Column(children: col1)),
                          const SizedBox(width: 16),
                          Expanded(child: Column(children: col2)),
                          const SizedBox(width: 16),
                          Expanded(child: Column(children: col3)),
                        ],
                      )
                    : Column(
                        children: [
                          ...col1,
                          const SizedBox(height: 16),
                          ...col2,
                          const SizedBox(height: 16),
                          ...col3,
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategoryCard(
    String category,
    IconData icon,
    List<String> skills,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDarkMode ? 0.05 : 0.03),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Text(
                      skill,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── EDUCATION ───────────────────────────────────────────────────────────

  Widget _buildEducationSection() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              isFrench ? 'Formation' : 'Education',
              Icons.school,
            ),
            const SizedBox(height: 24),
            _buildEducationCard(
              title: isFrench
                  ? 'Diplôme National d\'Ingénieur en Informatique (Niveau 7 CEC)'
                  : 'Engineering Degree in Computer Science (EQF Level 7)',
              school: isFrench
                  ? 'École Nationale des Sciences de l\'Informatique – ENSI'
                  : 'National Engineering School of Computer Science – ENSI',
              duration: '09/2020 – 07/2023',
              icon: Icons.computer_rounded,
            ),
            const SizedBox(height: 16),
            _buildEducationCard(
              title: isFrench
                  ? 'Licence en Mathématiques et Applications'
                  : 'Bachelor\'s Degree in Mathematics and Applications',
              school: isFrench
                  ? 'Institut Supérieur d\'Informatique et de Mathématiques – ISIMM'
                  : 'Higher Institute of Computer Science and Mathematics – ISIMM',
              duration: '09/2017 – 07/2020',
              icon: Icons.calculate_rounded,
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
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.06),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryColor.withOpacity(0.2),
                  _accentColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  school,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: _primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: _subtextColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      duration,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _subtextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on_rounded,
                      size: 13,
                      color: _subtextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tunisia',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _subtextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── CONTACT ─────────────────────────────────────────────────────────────

  Widget _buildContactSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF0D0B1A),
                  const Color(0xFF1A0F2E),
                  const Color(0xFF0F172A),
                ]
              : [
                  const Color(0xFF5B21B6),
                  const Color(0xFF4F46E5),
                  const Color(0xFF0284C7),
                ],
        ),
      ),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                isFrench ? 'Travaillons Ensemble' : 'Let\'s Work Together',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFrench ? 'Contactez-moi' : 'Get in Touch',
              style: GoogleFonts.playfairDisplay(
                fontSize: isMobile ? 32 : 42,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isFrench
                  ? 'Disponible pour des opportunités Mobile Engineering (Flutter & Android)'
                  : 'Available for Mobile Engineering opportunities (Flutter & Android)',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildContactCard(
                  Icons.email,
                  'Email',
                  'abircherif212@gmail.com',
                  () => _launchUrl('mailto:abircherif212@gmail.com'),
                ),
                _buildContactCard(
                  Icons.code,
                  'GitHub',
                  'github.com/abir739',
                  () => _launchUrl(githubUrl),
                ),
                _buildContactCard(
                  Icons.work,
                  'LinkedIn',
                  'Abir Cherif',
                  () => _launchUrl(linkedinUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String platform,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── FOOTER ──────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: isDarkMode ? const Color(0xFF0A0818) : const Color(0xFF1E1B4B),
      child: Column(
        children: [
          Text(
            '© 2026 Abir Cherif · Mobile Engineer | Flutter & Android',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            isFrench
                ? 'Développé avec Flutter · Déployé sur GitHub Pages'
                : 'Built with Flutter · Deployed on GitHub Pages',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
