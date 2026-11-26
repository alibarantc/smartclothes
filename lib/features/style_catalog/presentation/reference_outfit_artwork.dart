import 'package:flutter/material.dart';
import 'package:smartclothes/features/style_catalog/models/reference_outfit.dart';

/// Original vector sketch of a top, trousers and shoes. No external imagery.
class ReferenceOutfitArtwork extends StatelessWidget {
  const ReferenceOutfitArtwork({super.key, required this.outfit});

  final ReferenceOutfit outfit;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Özgün çizim: ${outfit.itemSummary}',
      image: true,
      child: Container(
        height: 125,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomPaint(painter: _OutfitPainter(outfit)),
      ),
    );
  }
}

class _OutfitPainter extends CustomPainter {
  const _OutfitPainter(this.outfit);

  final ReferenceOutfit outfit;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 185);
    final brush = Paint()..isAntiAlias = true;
    brush.color = Colors.black.withOpacity(0.06);
    canvas.drawOval(const Rect.fromLTWH(36, 171, 128, 10), brush);

    // A simple garment illustration; the tones vary per reference look.
    brush.color = Color(outfit.bottomColor);
    canvas.drawPath(
      Path()
        ..moveTo(76, 95)..lineTo(124, 95)..lineTo(129, 165)
        ..lineTo(107, 165)..lineTo(100, 123)..lineTo(93, 165)
        ..lineTo(71, 165)..close(),
      brush,
    );
    brush.color = Color(outfit.topColor);
    canvas.drawPath(
      Path()
        ..moveTo(79, 22)..lineTo(63, 29)..lineTo(43, 67)
        ..lineTo(63, 76)..lineTo(76, 51)..lineTo(74, 99)
        ..lineTo(126, 99)..lineTo(124, 51)..lineTo(137, 76)
        ..lineTo(157, 67)..lineTo(137, 29)..lineTo(121, 22)
        ..lineTo(108, 35)..lineTo(92, 35)..close(),
      brush,
    );
    // Collar and outline add legibility at smaller card sizes.
    brush
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = Colors.black.withOpacity(0.16);
    canvas.drawPath(Path()..moveTo(91, 30)..quadraticBezierTo(100, 44, 109, 30), brush);
    brush.style = PaintingStyle.fill;
    if (outfit.outerwear.isNotEmpty) {
      brush.color = Color(outfit.layerColor);
      canvas.drawPath(
        Path()..moveTo(77, 19)..lineTo(61, 30)..lineTo(43, 68)
          ..lineTo(57, 75)..lineTo(78, 50)..lineTo(78, 104)
          ..lineTo(92, 104)..lineTo(94, 40)..close(),
        brush,
      );
      canvas.drawPath(
        Path()..moveTo(123, 19)..lineTo(139, 30)..lineTo(157, 68)
          ..lineTo(143, 75)..lineTo(122, 50)..lineTo(122, 104)
          ..lineTo(108, 104)..lineTo(106, 40)..close(),
        brush,
      );
    }
    brush.color = const Color(0xFF4B5053);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(66, 162, 32, 12), const Radius.circular(5)),
      brush,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(102, 162, 32, 12), const Radius.circular(5)),
      brush,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OutfitPainter oldDelegate) =>
      oldDelegate.outfit.id != outfit.id;
}
