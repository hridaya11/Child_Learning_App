import 'package:flutter/material.dart';
import 'alphabets_screen.dart';
import 'numbers_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'audio_manager.dart';
import 'user_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserManager _userManager = UserManager.instance;
  final AudioManager _audioManager = AudioManager.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Play background music when home screen loads
    _audioManager.playBackgroundMusic();
    
    // Check if user needs to set up profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userManager.checkNeedsProfileSetup()) {
        _showProfileSetup();
      }
    });
  }

  void _showProfileSetup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(isInitialSetup: true),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A7BF7),
        title: const Text(
          'FunLearn Kids',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          // Sound toggle button
          IconButton(
            icon: Icon(
              _audioManager.isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _audioManager.toggleMute();
              });
            },
          ),
          // Profile button
          GestureDetector(
            onTap: () {
              _audioManager.playEffect('button_click');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                  'assets/images/avatars/${_userManager.currentUser.avatar}.png'
                ),
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback if image is missing
                },
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF5252),
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelColor: Colors.white,
          onTap: (index) {
            _audioManager.playEffect('tab_change');
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.abc),
              text: 'ABC',
            ),
            Tab(
              icon: Icon(Icons.numbers),
              text: '123',
            ),
            Tab(
              icon: Icon(Icons.emoji_events),
              text: 'Scores',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              // Fallback if image is missing
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white,
              ),
            ),
          ),
          
          // Tab content
          TabBarView(
            controller: _tabController,
            children: const [
              AlphabetsScreen(),
              NumbersScreen(),
              LeaderboardScreen(),
            ],
          ),
        ],
      ),
      
      // Floating mascot character
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _audioManager.playEffect('mascot_talk');
          _showHelpDialog();
        },
        backgroundColor: const Color(0xFFFFC107),
        child: Image.asset(
          'assets/images/mascot_face.png',
          height: 40,
          // Fallback if image is missing
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.help,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF4A7BF7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/mascot_face.png',
                    height: 60,
                    // Fallback if image is missing
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.help,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Foxy's Help",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Tap on cards to flip them!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Learn letters and numbers by exploring the cards. Each time you flip a card, you'll earn points!",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _audioManager.playEffect('button_click');
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Got it!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

