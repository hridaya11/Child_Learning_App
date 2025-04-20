import 'package:flutter/material.dart';
import 'flip_card.dart';
import 'audio_manager.dart';
import 'user_manager.dart';
import 'dart:math';

class AlphabetsScreen extends StatefulWidget {
  const AlphabetsScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetsScreen> createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends State<AlphabetsScreen> {
  final AudioManager _audioManager = AudioManager.instance;
  final UserManager _userManager = UserManager.instance;
  final _random = Random();
  
  // List of alphabets with example words and images
  final List<Map<String, dynamic>> alphabets = [
    {'letter': 'A', 'word': 'Apple', 'image': 'apple', 'color': '#FFC107'},
    {'letter': 'B', 'word': 'Ball', 'image': 'ball', 'color': '#FF5252'},
    {'letter': 'C', 'word': 'Cat', 'image': 'cat', 'color': '#4A7BF7'},
    {'letter': 'D', 'word': 'Dog', 'image': 'dog', 'color': '#FFC107'},
    {'letter': 'E', 'word': 'Elephant', 'image': 'elephant', 'color': '#FF5252'},
    {'letter': 'F', 'word': 'Fish', 'image': 'fish', 'color': '#4A7BF7'},
    {'letter': 'G', 'word': 'Giraffe', 'image': 'giraffe', 'color': '#FFC107'},
    {'letter': 'H', 'word': 'House', 'image': 'house', 'color': '#FF5252'},
    {'letter': 'I', 'word': 'Ice Cream', 'image': 'ice_cream', 'color': '#4A7BF7'},
    {'letter': 'J', 'word': 'Jellyfish', 'image': 'jellyfish', 'color': '#FFC107'},
    {'letter': 'K', 'word': 'Kite', 'image': 'kite', 'color': '#FF5252'},
    {'letter': 'L', 'word': 'Lion', 'image': 'lion', 'color': '#4A7BF7'},
    {'letter': 'M', 'word': 'Monkey', 'image': 'monkey', 'color': '#FFC107'},
    {'letter': 'N', 'word': 'Nest', 'image': 'nest', 'color': '#FF5252'},
    {'letter': 'O', 'word': 'Owl', 'image': 'owl', 'color': '#4A7BF7'},
    {'letter': 'P', 'word': 'Penguin', 'image': 'penguin', 'color': '#FFC107'},
    {'letter': 'Q', 'word': 'Queen', 'image': 'queen', 'color': '#FF5252'},
    {'letter': 'R', 'word': 'Rabbit', 'image': 'rabbit', 'color': '#4A7BF7'},
    {'letter': 'S', 'word': 'Sun', 'image': 'sun', 'color': '#FFC107'},
    {'letter': 'T', 'word': 'Tiger', 'image': 'tiger', 'color': '#FF5252'},
    {'letter': 'U', 'word': 'Umbrella', 'image': 'umbrella', 'color': '#4A7BF7'},
    {'letter': 'V', 'word': 'Violin', 'image': 'violin', 'color': '#FFC107'},
    {'letter': 'W', 'word': 'Whale', 'image': 'whale', 'color': '#FF5252'},
    {'letter': 'X', 'word': 'Xylophone', 'image': 'xylophone', 'color': '#4A7BF7'},
    {'letter': 'Y', 'word': 'Yo-yo', 'image': 'yoyo', 'color': '#FFC107'},
    {'letter': 'Z', 'word': 'Zebra', 'image': 'zebra', 'color': '#FF5252'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildProgressIndicator(),
          ),
          // Card grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: alphabets.length,
              itemBuilder: (context, index) {
                String itemId = 'alphabet_${alphabets[index]['letter']}';
                bool isCompleted = _userManager.currentUser.completedItems[itemId] ?? false;
                
                return FlipCard(
                  front: _buildFrontCard(index, isCompleted),
                  back: _buildBackCard(index),
                  color: Color(int.parse(alphabets[index]['color']!.substring(1, 7), radix: 16) + 0xFF000000),
                  onFlip: () {
                    _onCardFlipped(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    int totalItems = alphabets.length;
    int completedItems = 0;
    
    for (var i = 0; i < totalItems; i++) {
      String itemId = 'alphabet_${alphabets[i]['letter']}';
      if (_userManager.currentUser.completedItems[itemId] ?? false) {
        completedItems++;
      }
    }
    
    double progress = totalItems > 0 ? completedItems / totalItems : 0;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Alphabet Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A7BF7),
              ),
            ),
            Text(
              "$completedItems / $totalItems",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5252),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A7BF7)),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildFrontCard(int index, bool isCompleted) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                alphabets[index]['letter']!,
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A7BF7),
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Tap to learn",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (isCompleted)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBackCard(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          alphabets[index]['letter']!,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A7BF7),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'for',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          alphabets[index]['word']!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF5252),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/alphabets/${alphabets[index]['image']}.png',
              fit: BoxFit.cover,
              // Fallback if image is missing
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[500],
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onCardFlipped(int index) {
    // Play sound effect
    _audioManager.playEffect('card_flip');
    
    // Pronounce the letter
    _audioManager.pronounce(alphabets[index]['letter']!.toLowerCase());
    
    // Mark item as completed
    String itemId = 'alphabet_${alphabets[index]['letter']}';
    if (!(_userManager.currentUser.completedItems[itemId] ?? false)) {
      _userManager.markItemCompleted(itemId);
      
      // Award points
      int pointsEarned = 5 + _random.nextInt(5); // 5-10 points
      _userManager.addPoints(pointsEarned, isAlphabet: true);
      
      // Show reward animation
      _showRewardAnimation(context, pointsEarned);
      
      // Check for achievements
      _checkForAchievements();
    }
  }

  void _showRewardAnimation(BuildContext context, int points) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Opacity(
                opacity: value > 0.8 ? 2.0 - value * 2 : value,
                child: Transform.translate(
                  offset: Offset(0, -50 * value),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "+$points points!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            onEnd: () {
              overlayEntry.remove();
            },
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
  }

  void _checkForAchievements() {
    int completedCount = 0;
    for (var alphabet in alphabets) {
      String itemId = 'alphabet_${alphabet['letter']}';
      if (_userManager.currentUser.completedItems[itemId] ?? false) {
        completedCount++;
      }
    }
    
    if (completedCount >= 10 && !_userManager.currentUser.achievements.contains('alphabet_novice')) {
      _userManager.addAchievement('alphabet_novice');
      _showAchievement('Alphabet Novice', 'You learned 10 letters!');
    }
    
    if (completedCount >= 20 && !_userManager.currentUser.achievements.contains('alphabet_explorer')) {
      _userManager.addAchievement('alphabet_explorer');
      _showAchievement('Alphabet Explorer', 'You learned 20 letters!');
    }
    
    if (completedCount >= 26 && !_userManager.currentUser.achievements.contains('alphabet_master')) {
      _userManager.addAchievement('alphabet_master');
      _showAchievement('Alphabet Master', 'You learned all 26 letters!');
    }
  }

  void _showAchievement(String title, String description) {
    _audioManager.playEffect('achievement');
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 10),
              const Text(
                "Achievement Unlocked!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _audioManager.playEffect('button_click');
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF9800),
                ),
                child: const Text(
                  "Awesome!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

