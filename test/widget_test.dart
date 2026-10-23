import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/main.dart';

void main() {
  testWidgets('SmartClothes welcome screen displays title and app name',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartClothesApp());

    expect(find.text('SmartClothes'), findsWidgets);
    expect(find.text("SmartClothes'a Hoş Geldiniz"), findsOneWidget);
    expect(
      find.text(
        'Dolabını tanıyan, tarzını öğrenen kişiselleştirilmiş mobil stil asistanı.',
      ),
      findsOneWidget,
    );
  });
}
