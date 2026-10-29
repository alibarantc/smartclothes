import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/core/theme/app_theme.dart';
import 'package:smartclothes/core/widgets/smart_button.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_loading_indicator.dart';
import 'package:smartclothes/core/widgets/smart_section_header.dart';
import 'package:smartclothes/core/widgets/smart_text_field.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  group('SmartButton Widget Tests', () {
    testWidgets('calls onPressed when tapped in normal state', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          SmartButton(
            text: 'Kaydet',
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Kaydet'), findsOneWidget);
      await tester.tap(find.text('Kaydet'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when isDisabled is true', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          SmartButton(
            text: 'Devam Et',
            isDisabled: true,
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Devam Et'));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('shows loading spinner and hides text when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SmartButton(
            text: 'Yükleniyor',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Yükleniyor'), findsNothing);
      expect(find.byType(SmartLoadingIndicator), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SmartButton(
            text: 'İlerle',
            icon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('İlerle'), findsOneWidget);
    });
  });

  group('SmartCard Widget Tests', () {
    testWidgets('renders child content and responds to onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          SmartCard(
            onTap: () => tapped = true,
            child: const Text('Kart İçeriği'),
          ),
        ),
      );

      expect(find.text('Kart İçeriği'), findsOneWidget);
      await tester.tap(find.text('Kart İçeriği'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('SmartTextField Widget Tests', () {
    testWidgets('renders label and hint and accepts user input', (tester) async {
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        _wrap(
          SmartTextField(
            controller: controller,
            label: 'E-posta',
            hintText: 'ornek@email.com',
            onChanged: (val) => changedValue = val,
          ),
        ),
      );

      expect(find.text('E-posta'), findsOneWidget);
      expect(find.text('ornek@email.com'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'test@smartclothes.com');
      await tester.pump();

      expect(controller.text, equals('test@smartclothes.com'));
      expect(changedValue, equals('test@smartclothes.com'));
    });

    testWidgets('obscures text and toggles visibility for password field',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SmartTextField(
            label: 'Şifre',
            isPassword: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  group('SmartSectionHeader Widget Tests', () {
    testWidgets('renders title, subtitle, and triggers action callback',
        (tester) async {
      var actionTapped = false;

      await tester.pumpWidget(
        _wrap(
          SmartSectionHeader(
            title: 'Günün Kombini',
            subtitle: 'Bugünkü hava durumuna göre seçildi',
            actionText: 'Tümünü Gör',
            onActionPressed: () => actionTapped = true,
          ),
        ),
      );

      expect(find.text('Günün Kombini'), findsOneWidget);
      expect(find.text('Bugünkü hava durumuna göre seçildi'), findsOneWidget);
      expect(find.text('Tümünü Gör'), findsOneWidget);

      await tester.tap(find.text('Tümünü Gör'));
      await tester.pump();

      expect(actionTapped, isTrue);
    });
  });

  group('SmartLoadingIndicator Widget Tests', () {
    testWidgets('renders spinner and optional message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SmartLoadingIndicator(
            message: 'Gardırop yükleniyor...',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Gardırop yükleniyor...'), findsOneWidget);
    });
  });
}
