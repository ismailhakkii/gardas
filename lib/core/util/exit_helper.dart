import 'package:flutter/material.dart';
import 'dart:async';

/// Oyundan güvenli bir şekilde çıkış yapmaya yardımcı olan sınıf
class ExitHelper {
  /// Güvenli bir şekilde oyundan çıkış yapar
  /// 
  /// Bu metod, birden fazla çıkış stratejisi kullanarak sayfadan çıkmayı zorlar.
  /// UI thread'ini bloklamamak için asenkron olarak çalışır.
  static void exitGame(BuildContext context, {String? homeRoute}) {
    // İlk olarak navigator pop deneyin
    _safeNavigatorPop(context);
    
    // Eğer 200ms içinde pop işlemi başarısız olursa, diğer stratejileri deneyin
    Timer(const Duration(milliseconds: 200), () {
      if (ModalRoute.of(context)?.isCurrent == true) {
        // İlk strateji başarısız oldu, pushReplacement stratejisini deneyin
        _safePushReplacement(context, homeRoute);
      }
    });
  }

  /// Güvenli navigator pop
  static void _safeNavigatorPop(BuildContext context) {
    try {
      Navigator.pop(context);
    } catch (e) {
      print("Navigator pop failed: $e");
    }
  }

  /// Güvenli push replacement (pop başarısız olursa)
  static void _safePushReplacement(BuildContext context, String? homeRoute) {
    try {
      if (homeRoute != null) {
        Navigator.pushReplacementNamed(context, homeRoute);
      } else {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const Scaffold(
            body: Center(child: Text("Ana sayfaya dönülüyor...")),
          )),
        );
        
        // Biraz bekleyip ana sayfaya dönmeyi deneyin
        Timer(const Duration(milliseconds: 200), () {
          try {
            Navigator.popUntil(context, (route) => route.isFirst);
          } catch (e) {
            print("Navigation fallback failed: $e");
          }
        });
      }
    } catch (e) {
      print("Push replacement failed: $e");
    }
  }
}