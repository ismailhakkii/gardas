import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gardas/main.dart';
import 'package:gardas/presentation/routes/app_router.dart';


void main() {
  testWidgets('App başlatma testi', (WidgetTester tester) async {
    // Mock AppRouter
    
    // App'i oluştur
    await tester.pumpWidget(MyApp(appRouter: AppRouter()));
    
    // İlk frame
    await tester.pump();
    
    // Uygulama hata olmadan başlıyor mu kontrol et
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}