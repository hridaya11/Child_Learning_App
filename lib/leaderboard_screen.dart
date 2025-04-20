import 'package:flutter/material.dart';
import 'user_manager.dart';
import 'audio_manager.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  final UserManager _userManager = UserManager.instance;
  final AudioManager _audioManager = AudioManager.instance;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF4A7BF7).withOpacity(0.1),
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4A7BF7),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFFF5252),
            onTap: (_) {
              _audioManager.playEffect('tab_change');
            },
            tabs: const [
              Tab(text: "LEADERBOARD"),
              Tab(text: "ACHIEVEMENTS"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLeaderboardTab(),
              _buildAchievementsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardTab() {
    final leaderboard = _userManager.leaderboard;
    final currentUser = _userManager.currentUser;
    
    return Column(
      children: [
        // Current user stats
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFFFC107),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF4A7BF7),
                    backgroundImage: AssetImage(
                      'assets/images/avatars/${currentUser.avatar}.png'
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Fallback if image is missing
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A7BF7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your Score: ${currentUser.totalScore}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF5252),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Rank",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "${leaderboard.indexWhere((user) => user.name == currentUser.name) + 1}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreCard(
                    "ABC",
                    currentUser.alphabetScore,
                    Icons.abc,
                    const Color(0xFF4A7BF7),
                  ),
                  _buildScoreCard(
                    "123",
                    currentUser.numbersScore,
                    Icons.numbers,
                    const Color(0xFFFF5252),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Leaderboard title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFC107),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                "Top Players",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A7BF7),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    // Refresh leaderboard
                  });
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                  color: Color(0xFF4A7BF7),
                ),
                label: const Text(
                  "Refresh",
                  style: TextStyle(
                    color: Color(0xFF4A7BF7),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Leaderboard list
        Expanded(
          child: leaderboard.isEmpty
              ? const Center(
                  child: Text(
                    "No players yet. Be the first!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final user = leaderboard[index];
                    final isCurrentUser = user.name == currentUser.name;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? const Color(0xFFFFC107).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: isCurrentUser
                            ? Border.all(color: const Color(0xFFFFC107))
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: _getRankColor(index),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/images/avatars/${user.avatar}.png'
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                // Fallback if image is missing
                              },
                            ),
                          ],
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: isCurrentUser
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A7BF7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${user.totalScore} pts",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    final achievements = _userManager.currentUser.achievements;
    
    final allAchievements = [
      {
        'id': 'alphabet_novice',
        'title': 'Alphabet Novice',
        'description': 'Learn 10 letters',
        'icon': Icons.school,
        'color': const Color(0xFF4A7BF7),
      },
      {
        'id': 'alphabet_explorer',
        'title': 'Alphabet Explorer',
        'description': 'Learn 20 letters',
        'icon': Icons.explore,
        'color': const Color(0xFF4A7BF7),
      },
      {
        'id': 'alphabet_master',
        'title': 'Alphabet Master',
        'description': 'Learn all 26 letters',
        'icon': Icons.workspace_premium,
        'color': const Color(0xFF4A7BF7),
      },
      {
        'id': 'number_novice',
        'title': 'Number Novice',
        'description': 'Learn 5 numbers',
        'icon': Icons.filter_5,
        'color': const Color(0xFFFF5252),
      },
      {
        'id': 'number_master',
        'title': 'Number Master',
        'description': 'Learn all 10 numbers',
        'icon': Icons.filter_9_plus,
        'color': const Color(0xFFFF5252),
      },
    ];
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Your Achievements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A7BF7),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAchievementStat(
                    achievements.length,
                    allAchievements.length,
                    "Earned",
                    const Color(0xFFFFC107),
                  ),
                  _buildAchievementStat(
                    allAchievements.length - achievements.length,
                    allAchievements.length,
                    "Locked",
                    Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Achievements list
        ...allAchievements.map((achievement) {
          final isUnlocked = achievements.contains(achievement['id']);
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: isUnlocked
                  ? Border.all(color: achievement['color'] as Color)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? achievement['color'] as Color
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement['icon'] as IconData,
                  color: Colors.white,
                ),
              ),
              title: Text(
                achievement['title'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? achievement['color'] as Color
                      : Colors.grey[600],
                ),
              ),
              subtitle: Text(
                achievement['description'] as String,
                style: TextStyle(
                  color: isUnlocked ? null : Colors.grey[500],
                ),
              ),
              trailing: isUnlocked
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildScoreCard(String title, int score, IconData icon, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$score pts",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementStat(int value, int total, String label, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: total > 0 ? value / total : 0,
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              "$value/$total",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF4A7BF7); // Blue
    }
  }
}

