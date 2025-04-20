import 'package:flutter/material.dart';
import 'user_manager.dart';
import 'audio_manager.dart';

class ProfileScreen extends StatefulWidget {
  final bool isInitialSetup;
  
  const ProfileScreen({
    Key? key,
    this.isInitialSetup = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserManager _userManager = UserManager.instance;
  final AudioManager _audioManager = AudioManager.instance;
  
  late TextEditingController _nameController;
  String _selectedAvatar = 'fox';
  
  final List<String> _avatarOptions = [
    'fox', 'bear', 'cat', 'dog', 'koala', 'lion', 
    'monkey', 'panda', 'rabbit', 'tiger'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userManager.currentUser.name);
    _selectedAvatar = _userManager.currentUser.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    // Play sound effect
    _audioManager.playEffect('button_click');
    
    if (_nameController.text.isEmpty) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Update user profile
    await _userManager.updateUserName(_nameController.text);
    await _userManager.updateUserAvatar(_selectedAvatar);
    
    // Mark profile setup as completed if this is initial setup
    if (widget.isInitialSetup) {
      await _userManager.completeProfileSetup();
    }
    
    // Close the screen
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isInitialSetup ? 'Welcome!' : 'Edit Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A7BF7),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/profile_bg.png',
              fit: BoxFit.cover,
              // Fallback if image is missing
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white,
              ),
            ),
          ),
          
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isInitialSetup) ...[
                  const Center(
                    child: Text(
                      "Let's set up your profile!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7BF7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Name input
                const Text(
                  "Your Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A7BF7),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter your name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF4A7BF7),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFC107),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  onChanged: (_) {
                    _audioManager.playEffect('key_press');
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Avatar selection
                const Text(
                  "Choose an Avatar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A7BF7),
                  ),
                ),
                const SizedBox(height: 10),
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
                    border: Border.all(
                      color: const Color(0xFF4A7BF7),
                      width: 2,
                    ),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _avatarOptions.length,
                    itemBuilder: (context, index) {
                      final avatar = _avatarOptions[index];
                      final isSelected = avatar == _selectedAvatar;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = avatar;
                          });
                          _audioManager.playEffect('button_click');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFF5252)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatars/$avatar.png'
                            ),
                            backgroundColor: Colors.grey[200],
                            onBackgroundImageError: (exception, stackTrace) {
                              // Fallback if image is missing
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Save button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.save),
                        const SizedBox(width: 10),
                        Text(
                          widget.isInitialSetup ? "Let's Go!" : "Save Profile",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (!widget.isInitialSetup) ...[
                  const SizedBox(height: 20),
                  
                  // Reset progress button
                  Center(
                    child: TextButton.icon(
                      onPressed: _showResetConfirmation,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Reset Progress",
                        style: TextStyle(
                          color: Colors.red,
                        ),
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

  void _showResetConfirmation() {
    _audioManager.playEffect('alert');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Progress"),
        content: const Text(
          "Are you sure you want to reset all your progress? This will erase all scores and achievements.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              _audioManager.playEffect('button_click');
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              _audioManager.playEffect('button_click');
              await _userManager.resetProgress();
              Navigator.of(context).pop();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress has been reset'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}

