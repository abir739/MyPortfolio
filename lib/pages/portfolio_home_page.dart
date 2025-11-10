import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parallax_animation/parallax_animation.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final String githubUrl = 'https://github.com/abir739';
  final String linkedinUrl =
      'https://www.linkedin.com/in/abir-cherif-931770202/';
  final String portfolioUrl = 'https://abir739.github.io/personal_website/';
  final String cvPath = "assets/pdf/Abir Cherif CV.pdf";
  final ScrollController _scrollController = ScrollController();

  Future<void> _launchUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      // Check if URL can be launched
      if (await canLaunchUrl(uri)) {
        // Try to launch with external application mode first
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          // If external fails, try in-app web view
          try {
            await launchUrl(
              uri,
              mode: LaunchMode.inAppWebView,
              webViewConfiguration: const WebViewConfiguration(
                enableJavaScript: true,
                enableDomStorage: true,
              ),
            );
          } catch (e) {
            // If in-app fails, try platform default
            await launchUrl(uri);
          }
        }
      } else {
        // If canLaunchUrl returns false, try alternative approaches
        bool launched = false;

        // Try different launch modes
        final List<LaunchMode> modes = [
          LaunchMode.externalApplication,
          LaunchMode.inAppWebView,
          LaunchMode.platformDefault,
        ];

        for (LaunchMode mode in modes) {
          try {
            await launchUrl(uri, mode: mode);
            launched = true;
            break;
          } catch (e) {
            continue;
          }
        }

        if (!launched) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch URL: $url'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching URL: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _openCVInNewTab() async {
    const String cvUrl =
        'https://abir739.github.io/personal_website/assets/pdf/Abir Cherif CV.pdf';

    await _launchUrl(cvUrl, context);
  }

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _downloadCV() async {
    const String cvUrl =
        'https://raw.githubusercontent.com/abir739/personal_website/main/assets/pdf/Abir Cherif CV.pdf';

    if (kIsWeb) {
      // For web, show a message about downloading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Opening CV in new tab. Right-click and "Save as" to download.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening CV in browser...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    await _launchUrl(cvUrl, context);
  }

//  method for downloading portfolio
  void _downloadPortfolio() {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Portfolio is already displayed on this website. Use "Download CV" instead.'),
        ),
      );

      // _downloadCV();
    } else {
      // For mobile, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Portfolio download not available on mobile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Abir Cherif',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: () => _openCVInNewTab(),
            tooltip: 'View CV',
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => _downloadCV(),
            tooltip: 'Download CV',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                ),
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.blue),
              title: const Text('Experience'),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection(600);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: const Text('Education'),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection(1200);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.blue),
              title: const Text('Skills'),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection(1800);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.blue),
              title: const Text('Contact'),
              onTap: () =>
                  _launchUrl('mailto:abircherif212@gmail.com', context),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () =>
                _launchUrl('mailto:abircherif212@gmail.com', context),
            backgroundColor: Colors.blue.shade700,
            tooltip: 'Contact Me',
            child: const Icon(Icons.email),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _scrollToSection(0),
            backgroundColor: Colors.blue.shade700,
            tooltip: 'Back to Top',
            child: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Parallax
            Container(
              constraints: const BoxConstraints(minHeight: 300, maxHeight: 600),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ParallaxArea(
                child: ParallaxWidget(
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ZoomIn(
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage:
                                  const AssetImage('assets/images/img.jpg'),
                              backgroundColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Abir Cherif',
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Mobile Developer | Flutter Expert',
                            style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 18
                                  : 22,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Monastir, Tunisia | abircherif212@gmail.com | +216 93649677',
                              style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width < 600
                                        ? 14
                                        : 16,
                                color: Colors.white60,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Responsive button layout
                          MediaQuery.of(context).size.width < 600
                              ? Column(
                                  children: [
                                    ElasticIn(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _openCVInNewTab(),
                                          icon: const Icon(Icons.visibility),
                                          label: const Text('View CV'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElasticIn(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _downloadCV(),
                                          icon: const Icon(Icons.download),
                                          label: const Text('Download CV'),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElasticIn(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _openCVInNewTab(),
                                        icon: const Icon(Icons.visibility),
                                        label: const Text('View CV'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElasticIn(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _downloadCV(),
                                        icon: const Icon(Icons.download),
                                        label: const Text('Download CV'),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Professional Summary
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Summary',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Flutter Developer specialized in high-performance cross-platform mobile applications built with MVVM architecture. Proven experience in publishing and maintaining production apps on the Google Play Store and the App Store. Expert in CI/CD pipelines, Firebase integrations, and advanced state management (GetX, BLoC, Riverpod). Committed to delivering clean, well-tested code and exceptional user experiences in Agile/Scrum environments.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Experience Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: FadeInRight(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Experience',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExperienceCard(
                      'Mobile Developer',
                      'Continuous Net, Sousse, Tunisia',
                      'July 2023 - Present',
                      [
                        'Led development of a trip management app using Flutter and Dart, reducing organization time by 30% with real-time data updates and Firebase integration.',
                        'Collaborated with backend teams to integrate REST APIs in an Agile environment, ensuring seamless data flow.',
                        'Conducted usability testing and A/B testing, improving user retention by 20%.',
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildExperienceCard(
                      'Mobile Development Intern',
                      'Continuous Net, Sousse, Tunisia',
                      'Feb 2023 - June 2023',
                      [
                        'Developed and launched a mobile app using Flutter and Dart for organized trips, streamlining user workflows by 15%.',
                        'Implemented Firebase notifications for real-time updates.',
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildExperienceCard(
                      'Web Development Intern',
                      'DRÄXLMAIER Group, Monastir, Tunisia',
                      'June 2022 - Aug 2022',
                      [
                        'Optimized a document archiving web app using PHP and Laravel, reducing load times by 25%.',
                        'Enhanced UI with HTML, CSS, JavaScript, and Bootstrap for better usability.',
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Education Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Education',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildEducationCard(
                      'Diploma: Computer Engineering (equivalent to Master’s Degree – EQF Level 7)',
                      '🏫 National Engineering School of Computer Science (ENSI), Manouba, Tunisia',
                      'Sep. 2020 – Jul. 2023',
                    ),
                    const SizedBox(height: 16),
                    _buildEducationCard(
                      'Bachelor’s Degree in Mathematics and Applications',
                      '🏫 Higher Institute of Computer Science and Mathematics of Monastir(ISIMM), Tunisia',
                      'Sep. 2017 – Jul. 2020',
                    ),
                  ],
                ),
              ),
            ),
            // Skills Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        'Flutter',
                        'Dart',
                        'JavaScript',
                        'PHP',
                        'HTML',
                        'CSS',
                        'CI/CD Pipeline',
                        'Bootstrap',
                        'MySQL',
                        'Firebase',
                        'Git',
                        'GitLab',
                        'Agile/SCRUM',
                        'REST APIs',
                        'State Management (Provider, Bloc)',
                      ]
                          .map((skill) => Chip(
                                label: Text(
                                  skill,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: Colors.blue.shade100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                elevation: 2,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Languages Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: FadeInRight(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Languages',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        'Arabic (Native)',
                        'English (Fluent)',
                        'French (Fluent)',
                      ]
                          .map((lang) => Chip(
                                label: Text(
                                  lang,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: Colors.blue.shade100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                elevation: 2,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Projects Released Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projects Released',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProjectReleasedCard(
                      'Sunshine Vacances',
                      'A Flutter-based travel app for managing claims, accommodations, and transfers, using Firebase, HTTP, and REST APIs. Published on Play Store and App Store.',
                      // 'https://play.google.com/store/apps/details?id=com.zenify_client_app',
                      'https://play.google.com/store/apps/developer?id=SunshineVacances.fr',
                      context,
                      image: 'assets/images/sunshine.png',
                    ),
                    const SizedBox(height: 16),
                    _buildProjectReleasedCard(
                      'Tunisie Promo',
                      'A mobile app for discovering promotions in Tunisia, built with Flutter and integrated with Firebase. Published on Play Store and App Store.',
                      // 'https://play.google.com/store/search?q=tunisie%20promo&c=apps',
                      'https://play.google.com/store/apps/dev?id=7728432506457419444',
                      context,
                      image: 'assets/images/tunisie_promo.png',
                    ),
                  ],
                ),
              ),
            ),
            // Projects Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projects',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProjectCard(
                      title: 'Instagram Clone',
                      description:
                          'A Flutter app mimicking Instagram with Firebase authentication, feed, and chat functionality.',
                      url: 'https://github.com/abir739/Instagram-Clone',
                      image: 'assets/images/instagram_clone.png',
                    ),
                    const SizedBox(height: 16),
                    _buildProjectCard(
                      title: 'Voyageur App',
                      description:
                          'A travel app for managing accommodations and transfers with real-time data and Firebase integration.',
                      url: 'https://github.com/abir739/Voyageur_app',
                      image: 'assets/images/voyageur.png',
                    ),
                    const SizedBox(height: 16),
                    _buildProjectCard(
                      title: 'Habit Tracker',
                      description:
                          'A Flutter app for tracking daily habits with Provider state management and local storage.',
                      url:
                          'https://github.com/abir739/Habit-Tracker-Flutter-app',
                      image: 'assets/images/habit_tracker.png',
                    ),
                    const SizedBox(height: 16),
                    _buildProjectCard(
                      title: 'Guide App',
                      description:
                          'A tourist guide app with user profiles, notifications, and offline support.',
                      url: 'https://github.com/abir739/Guide_app',
                      image: 'assets/images/guide_app.png',
                    ),
                    const SizedBox(height: 16),
                    _buildProjectCard(
                      title: 'Quiz App',
                      description:
                          'A cross-platform quiz app with local storage, scoring, and dynamic question loading.',
                      url: 'https://github.com/abir739/Quiz_App',
                      image: 'assets/images/quiz_app.png',
                    ),
                  ],
                ),
              ),
            ),
            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Text(
                      'Get in Touch',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Responsive contact buttons
                    MediaQuery.of(context).size.width < 600
                        ? Column(
                            children: [
                              ElasticIn(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _launchUrl(githubUrl, context),
                                    icon: const Icon(Icons.code, size: 20),
                                    label: const Text('GitHub'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue.shade900,
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElasticIn(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _launchUrl(linkedinUrl, context),
                                    icon: const Icon(Icons.link, size: 20),
                                    label: const Text('LinkedIn'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue.shade900,
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElasticIn(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openCVInNewTab(),
                                    icon: const Icon(Icons.download, size: 20),
                                    label: const Text('View CV'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue.shade900,
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElasticIn(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _launchUrl(githubUrl, context),
                                  icon: const Icon(Icons.code, size: 20),
                                  label: const Text('GitHub'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade900,
                                    elevation: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElasticIn(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _launchUrl(linkedinUrl, context),
                                  icon: const Icon(Icons.link, size: 20),
                                  label: const Text('LinkedIn'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade900,
                                    elevation: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElasticIn(
                                child: ElevatedButton.icon(
                                  onPressed: () => _openCVInNewTab(),
                                  icon: const Icon(Icons.download, size: 20),
                                  label: const Text('View CV'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade900,
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    Text(
                      'Download my portfolio as a PDF to include with your job applications:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _downloadPortfolio(),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Portfolio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade900,
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(String title, String company, String duration,
      List<String> responsibilities) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
              Text(
                company,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                duration,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 12),
              ...responsibilities.map((resp) => Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right,
                            size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            resp,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard(
      String degree, String institution, String duration) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                degree,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
              Text(
                institution,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                duration,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificationCard(
      String title, String issuer, String year, String description) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
              Text(
                '$issuer, $year',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectReleasedCard(
      String title, String description, String url, BuildContext context,
      {String? image}) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              if (image != null) const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _launchUrl(url, context),
                      child: Text(
                        'View on Store',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
      {required String title,
      required String description,
      required String url,
      String? image}) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MediaQuery.of(context).size.width < 600
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            image,
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (image != null) const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _launchUrl(url, context),
                        child: Text(
                          'View on GitHub',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          image,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (image != null) const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => _launchUrl(url, context),
                            child: Text(
                              'View on GitHub',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
