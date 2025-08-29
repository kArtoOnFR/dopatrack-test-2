// import 'package:flutter/material.dart';
//
// class MeasuredOverlayWidget extends StatefulWidget {
//   final Widget child;
//   final void Function(Size) onSize;
//
//   const MeasuredOverlayWidget({
//     super.key,
//     required this.child,
//     required this.onSize,
//   });
//
//   @override
//   State<MeasuredOverlayWidget> createState() => _MeasuredOverlayWidgetState();
// }
//
// class _MeasuredOverlayWidgetState extends State<MeasuredOverlayWidget> {
//   final _key = GlobalKey();
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final context = _key.currentContext;
//       if (context != null) {
//         final size = context.size;
//         if (size != null) {
//           widget.onSize(size);
//         }
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: 0,
//       child: Container(
//         key: _key,
//         child: widget.child,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

/// Mesure la taille réelle du [child] et la retourne via [onSize].
/// - Pas d’estimation : la mesure est faite après layout.
/// - N’ajoute pas de contraintes artificielles.
/// - Utile pour positionner précisément un overlay.
class MeasuredOverlayWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSize;

  const MeasuredOverlayWidget({
    super.key,
    required this.child,
    required this.onSize,
  });

  @override
  State<MeasuredOverlayWidget> createState() => _MeasuredOverlayWidgetState();
}

class _MeasuredOverlayWidgetState extends State<MeasuredOverlayWidget> {
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // On mesure au tout premier frame disponible
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
  }

  @override
  void didUpdateWidget(covariant MeasuredOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
  }

  void _notifySize() {
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final renderBox = ctx.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    widget.onSize(renderBox.size);
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
