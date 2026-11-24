import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_badge_plus/app_badge_plus.dart';

final badgeProvider = StateNotifierProvider<BadgeNotifier, int>((ref) {
  return BadgeNotifier();
});

class BadgeNotifier extends StateNotifier<int> {
  BadgeNotifier() : super(0) {
    _loadInitialBadge();
  }

  Future<void> _loadInitialBadge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBadge = prefs.getInt('badge_count') ?? 0;
      state = savedBadge;

      debugPrint("✅ Badge cargado desde SharedPreferences: $savedBadge");
    } catch (e) {
      debugPrint("❌ Error cargando badge inicial: $e");
    }
  }

  Future<void> syncWithSystemBadge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final systemBadge = prefs.getInt('badge_count') ?? 0;

      if (systemBadge != state) {
        debugPrint("🔄 Sincronizando badge interno con sistema: $systemBadge (era $state)");
        state = systemBadge;
      }
    } catch (e) {
      debugPrint("❌ Error sincronizando con sistema: $e");
    }
  }

  Future<void> _updateSystemBadge(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('badge_count', count);
      await AppBadgePlus.updateBadge(count);

      debugPrint("📱 Badge del sistema actualizado: $count");
    } catch (e) {
      debugPrint("❌ Error actualizando badge del sistema: $e");
    }
  }

  Future<void> setBadge(int value) async {
    try {
      final newValue = value.clamp(0, 999);
      state = newValue;

      await _updateSystemBadge(newValue);

      debugPrint("🎯 Badge establecido: $newValue");
    } catch (e) {
      debugPrint("❌ Error estableciendo badge: $e");
    }
  }

  Future<void> increment() async {
    await setBadge(state + 1);
  }

  Future<void> decrement() async {
    if (state > 0) {
      await setBadge(state - 1);
    }
  }

  Future<void> clear() async {
    await setBadge(0);
  }

  Future<bool> isSupported() async {
    return AppBadgePlus.isSupported();
  }
}