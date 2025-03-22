import 'package:flutter/material.dart';
import 'connectivity_overlay.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityOverlay(child: child);
  }
} 