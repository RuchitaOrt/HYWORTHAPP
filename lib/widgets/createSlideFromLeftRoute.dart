import 'package:flutter/material.dart';

Route createSlideFromLeftRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(-1.0, 0.0); // Start from left
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
Route createSlideFromBottomRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600), // Slower animation
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.0, 1.0); // Start from bottom
      const end = Offset.zero;
      const curve = Curves.easeOut; // Smoother curve

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Route createSlideFrom70BottomRoute(Widget page,double dy) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      var begin = Offset(0.0, dy); // Start from 70% of screen height
      const end = Offset.zero;
      const curve = Curves.easeOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
Route createSlideFromTopRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 100),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.0, -1.0), // from top
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ));

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
Route createSlideFromRightRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0); // Start from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
