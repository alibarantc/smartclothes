import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/app/smart_clothes_app.dart';
import 'package:smartclothes/core/navigation/main_navigation_screen.dart';
import 'package:smartclothes/core/theme/app_theme.dart';
import 'package:smartclothes/features/home/presentation/home_screen.dart';
import 'package:smartclothes/features/outfits/presentation/outfits_screen.dart';
import 'package:smartclothes/features/profile/presentation/profile_screen.dart';
import 'package:smartclothes/features/wardrobe/presentation/wardrobe_screen.dart';

void main() {
  group('MainNavigationScreen Widget Tests', () {
    testWidgets('Renders all four navigation destinations with labels and icons',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const MainNavigationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all four tabs exist in the NavigationBar
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Ana Sayfa'), findsOneWidget);
      expect(find.text('Dolabım'), findsWidgets); // tab label + screen title
      expect(find.text('Kombinler'), findsWidgets); // tab label + quick access
      expect(find.text('Profil'), findsWidgets); // tab label + screen title

      // Default selected index should be 0 (HomeScreen)
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Bugün ne giysem?'), findsOneWidget);
      expect(find.text('Hava Durumu'), findsOneWidget);
      expect(find.text('Günün Kombin Önerisi'), findsOneWidget);
      expect(find.text('Stil Kutusu'), findsOneWidget);
    });

    testWidgets('Switches tabs and displays respective screen scaffolds',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const MainNavigationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Switch to 'Dolabım' (tab index 1)
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Dolabım'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WardrobeScreen), findsOneWidget);
      expect(find.text('Dolabın henüz boş'), findsOneWidget);
      expect(find.text('Kıyafet Ekleme Özelliği Yakında'), findsOneWidget);

      // 2. Switch to 'Kombinler' (tab index 2)
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Kombinler'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OutfitsScreen), findsOneWidget);
      expect(find.text('Kombinlerim'), findsOneWidget);
      expect(find.text('Henüz oluşturulmuş bir kombin yok'), findsOneWidget);
      expect(find.text('Akıllı Kombin Motoru Yakında'), findsOneWidget);

      // 3. Switch to 'Profil' (tab index 3)
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Profil'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Misafir Kullanıcı'), findsOneWidget);
      expect(find.text('Stil Tercihleri'), findsOneWidget);
      expect(find.text('Bütçe Tercihleri'), findsOneWidget);
      expect(find.text('Uygulama Ayarları'), findsOneWidget);

      // 4. Switch back to 'Ana Sayfa' (tab index 0)
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Ana Sayfa'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Bugün ne giysem?'), findsOneWidget);
    });

    testWidgets('Quick access cards on HomeScreen navigate to respective tabs',
        (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const MainNavigationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap 'Dolabım' quick access card
      await tester.tap(find.text('Kıyafetlerini yönet'));
      await tester.pumpAndSettle();

      expect(find.byType(WardrobeScreen), findsOneWidget);
      expect(find.text('Dolabın henüz boş'), findsOneWidget);

      // Return to home
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Ana Sayfa'),
        ),
      );
      await tester.pumpAndSettle();

      // Tap 'Kombinler' quick access card
      await tester.tap(find.text('Koleksiyonunu keşfet'));
      await tester.pumpAndSettle();

      expect(find.byType(OutfitsScreen), findsOneWidget);
      expect(find.text('Kombinlerim'), findsOneWidget);
    });

    testWidgets('PopScope navigates back to Home tab when on another tab',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const MainNavigationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Go to tab 2 (Kombinler)
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Kombinler'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OutfitsScreen), findsOneWidget);

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 2);

      // Simulate Android back button press
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Should have returned to Home tab (index 0)
      final updatedNavBar =
          tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(updatedNavBar.selectedIndex, 0);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('App starts at WelcomeScreen and tapping Başla navigates to MainNavigation',
        (tester) async {
      await tester.pumpWidget(const SmartClothesApp());
      await tester.pumpAndSettle();

      // Verify on WelcomeScreen
      expect(find.text('Başla'), findsOneWidget);
      expect(find.byType(MainNavigationScreen), findsNothing);

      // Tap 'Başla'
      await tester.tap(find.text('Başla'));
      await tester.pumpAndSettle();

      // Verify MainNavigationScreen and HomeScreen are visible
      expect(find.byType(MainNavigationScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('Dark theme renders properly with MainNavigationScreen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: const MainNavigationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MainNavigationScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Ana Sayfa'), findsOneWidget);
    });
  });
}
