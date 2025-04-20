import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  AudioManager._privateConstructor();
  static final AudioManager _instance = AudioManager._privateConstructor();
  static AudioManager get instance => _instance;

  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _pronunciationPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  Future<void> init() async {
    // Set background music to loop
    await _backgroundPlayer.setLoopMode(LoopMode.one);
    await _backgroundPlayer.setVolume(0.3);
    
    // Pre-load common sound effects
    await _loadSoundEffects();
  }

  Future<void> _loadSoundEffects() async {
    // In a real app, preload common sound effects here
  }

  Future<void> playBackgroundMusic() async {
    if (_isMuted) return;
    try {
      await _backgroundPlayer.setAsset('assets/audio/background_music.mp3');
      await _backgroundPlayer.play();
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  Future<void> playEffect(String effectName) async {
    if (_isMuted) return;
    try {
      await _effectPlayer.setAsset('assets/audio/effects/$effectName.mp3');
      await _effectPlayer.play();
    } catch (e) {
      debugPrint('Error playing effect $effectName: $e');
    }
  }

  Future<void> pronounce(String text) async {
    if (_isMuted) return;
    try {
      await _pronunciationPlayer.setAsset('assets/audio/pronounce/$text.mp3');
      await _pronunciationPlayer.play();
    } catch (e) {
      debugPrint('Error pronouncing $text: $e');
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _backgroundPlayer.pause();
    } else {
      _backgroundPlayer.play();
    }
  }

  void dispose() {
    _effectPlayer.dispose();
    _pronunciationPlayer.dispose();
    _backgroundPlayer.dispose();
  }
}

