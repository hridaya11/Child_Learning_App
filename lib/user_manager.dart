import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserData {
  String name;
  String avatar;
  int totalScore;
  int alphabetScore;
  int numbersScore;
  List<String> achievements;
  Map<String, bool> completedItems;

  UserData({
    this.name = 'Player',
    this.avatar = 'fox',
    this.totalScore = 0,
    this.alphabetScore = 0,
    this.numbersScore = 0,
    List<String>? achievements,
    Map<String, bool>? completedItems,
  }) : 
    achievements = achievements ?? [],
    completedItems = completedItems ?? {};

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? 'Player',
      avatar: json['avatar'] ?? 'fox',
      totalScore: json['totalScore'] ?? 0,
      alphabetScore: json['alphabetScore'] ?? 0,
      numbersScore: json['numbersScore'] ?? 0,
      achievements: List<String>.from(json['achievements'] ?? []),
      completedItems: Map<String, bool>.from(json['completedItems'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'totalScore': totalScore,
      'alphabetScore': alphabetScore,
      'numbersScore': numbersScore,
      'achievements': achievements,
      'completedItems': completedItems,
    };
  }
}

class UserManager {
  UserManager._privateConstructor();
  static final UserManager _instance = UserManager._privateConstructor();
  static UserManager get instance => _instance;

  late SharedPreferences _prefs;
  UserData _currentUser = UserData();
  List<UserData> _leaderboard = [];

  UserData get currentUser => _currentUser;
  List<UserData> get leaderboard => _leaderboard;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCurrentUser();
    _loadLeaderboard();
  }

  void _loadCurrentUser() {
    final userJson = _prefs.getString('currentUser');
    if (userJson != null) {
      _currentUser = UserData.fromJson(json.decode(userJson));
    } else {
      // First time user, show profile setup next
      _prefs.setBool('needsProfileSetup', true);
    }
  }

  void _loadLeaderboard() {
    final leaderboardJson = _prefs.getString('leaderboard');
    if (leaderboardJson != null) {
      final List<dynamic> decoded = json.decode(leaderboardJson);
      _leaderboard = decoded.map((item) => UserData.fromJson(item)).toList();
    }
  }

  Future<void> saveCurrentUser() async {
    await _prefs.setString('currentUser', json.encode(_currentUser.toJson()));
    _updateLeaderboard();
  }

  Future<void> updateUserName(String name) async {
    _currentUser.name = name;
    await saveCurrentUser();
  }

  Future<void> updateUserAvatar(String avatar) async {
    _currentUser.avatar = avatar;
    await saveCurrentUser();
  }

  Future<void> addPoints(int points, {bool isAlphabet = true}) async {
    _currentUser.totalScore += points;
    if (isAlphabet) {
      _currentUser.alphabetScore += points;
    } else {
      _currentUser.numbersScore += points;
    }
    await saveCurrentUser();
  }

  Future<void> markItemCompleted(String itemId) async {
    _currentUser.completedItems[itemId] = true;
    await saveCurrentUser();
  }

  Future<void> addAchievement(String achievement) async {
    if (!_currentUser.achievements.contains(achievement)) {
      _currentUser.achievements.add(achievement);
      await saveCurrentUser();
    }
  }

  void _updateLeaderboard() {
    // Check if user already exists in leaderboard
    final existingIndex = _leaderboard.indexWhere(
      (user) => user.name == _currentUser.name
    );
    
    if (existingIndex >= 0) {
      _leaderboard[existingIndex] = _currentUser;
    } else {
      _leaderboard.add(_currentUser);
    }
    
    // Sort leaderboard by total score (descending)
    _leaderboard.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    
    // Keep only top 10 scores
    if (_leaderboard.length > 10) {
      _leaderboard = _leaderboard.sublist(0, 10);
    }
    
    // Save to persistent storage
    _prefs.setString('leaderboard', json.encode(
      _leaderboard.map((user) => user.toJson()).toList()
    ));
  }

  bool checkNeedsProfileSetup() {
    return _prefs.getBool('needsProfileSetup') ?? false;
  }

  Future<void> completeProfileSetup() async {
    await _prefs.setBool('needsProfileSetup', false);
  }

  Future<void> resetProgress() async {
    _currentUser = UserData(name: _currentUser.name, avatar: _currentUser.avatar);
    await saveCurrentUser();
  }
}

