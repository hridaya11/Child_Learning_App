import 'package:flutter/material.dart';
import 'flip_card.dart';
import 'audio_manager.dart';
import 'user_manager.dart';
import 'dart:math';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({Key? key}) : super(key: key);

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  final AudioManager _audioManager = AudioManager.instance;
  final UserManager _userManager = UserManager.instance;
  final _random = Random();
  
  // List of numbers with example images
  final List<Map<String, dynamic>> numbers = [
    {'number': '1', 'word': 'One', 'items': 1, 'image': 'number1', 'color': '#FFC107'},
    {'number': '2', 'word': 'Two', 'items': 2, 'image': 'number2', 'color': '#FF5252'},
    {'number': '3', 'word': 'Three', 'items': 3, 'image': 'number3', 'color': '#4A7BF7'},
    {'number': '4', 'word': 'Four', 'items': 4, 'image': 'number4', 'color': '#FFC107'},
    {'number': '5', 'word': 'Five', 'items': 5, 'image': 'number5', 'color': '#FF5252'},
    {'number': '6', 'word': 'Six', 'items': 6, 'image': 'number6', 'color': '#4A7BF7'},
    {'number': '7', 'word': 'Seven', 'items': 7, 'image': 'number7', 'color': '#FFC107'},
    {'number': '8', 'word': 'Eight', 'items': 8, 'image': 'number8', 'color': '#FF5252'},
    {'number': '9', 'word': 'Nine', 'items': 9, 'image': 'number9', 'color': '#4A7BF7'},
    {'number': '10', 'word': 'Ten', 'items': 10, 'image': 'number10', 'color': '#FFC107'},
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
              itemCount: numbers.length,
              itemBuilder: (context, index) {
                String itemId = 'number_${numbers[index]['number']}';
                bool isCompleted = _userManager.currentUser.completedItems[itemId] ?? false;
                
                return FlipCard(
                  front: _buildFrontCard(index, isCompleted),
                  back: _buildBackCard(index),
                  color: Color(int.parse(numbers[index]['color']!.substring(1, 7), radix: 16) + 0xFF000000),
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
    int totalItems = numbers.length;
    int completedItems = 0;
    
    for (var i = 0; i < totalItems; i++) {
      String itemId = 'number_${numbers[i]['number']}';
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
              "Numbers Progress",
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
                numbers[index]['number']!,
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
          numbers[index]['number']!,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A7BF7),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          numbers[index]['word']!,
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
              'assets/images/numbers/${numbers[index]['image']}.png',
              fit: BoxFit.cover,
              // Fallback if image is missing
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: _buildDots(numbers[index]['items']),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDots(int count) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          count,
          (index) => Container(
            width: count > 6 ? 12 : 16,
            height: count > 6 ? 12 : 16,
            decoration: const BoxDecoration(
              color: Color(0xFF4A7BF7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void _onCardFlipped(int index) {
    // Play sound effect
    _audioManager.playEffect('card_flip');
    
    // Pronounce the number
    _audioManager.pronounce(numbers[index]['number']!);
    
    // Mark item as completed
    String itemId = 'number_${numbers[index]['number']}';
    if (!(_userManager.currentUser.completedItems[itemId] ?? false)) {
      _userManager.markItemCompleted(itemId);
      
      // Award points
      int pointsEarned = 5 + _random.nextInt(5); // 5-10 points
      _userManager.addPoints(pointsEarned, isAlphabet: false);
      
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
    for (var number in numbers) {
      String itemId = 'number_${number['number']}';
      if (_userManager.currentUser.completedItems[itemId] ?? false) {
        completedCount++;
      }
    }
    
    if (completedCount >= 5 && !_userManager.currentUser.achievements.contains('number_novice')) {
      _userManager.addAchievement('number_novice');
      _showAchievement('Number Novice', 'You learned 5 numbers!');
    }
    
    if (completedCount >= 10 && !_userManager.currentUser.achievements.contains('number_master')) {
      _userManager.addAchievement('number_master');
      _showAchievement('Number Master', 'You learned all 10 numbers!');
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

