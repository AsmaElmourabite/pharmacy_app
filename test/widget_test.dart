// This is a basic Flutter widget test for the Pharmacy App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pharmacy_app/main.dart';
import 'package:pharmacy_app/services/app_state.dart';

void main() {
  testWidgets('Pharmacy App launches and shows welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const PharmacyApp(),
      ),
    );

    // Verify that the welcome screen appears
    expect(find.text('Gestion de Pharmacie'), findsOneWidget);
    expect(find.text('Application de gestion pour pharmaciens et fournisseurs'), findsOneWidget);
    
    // Verify that the login and signup buttons are present
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('S\'inscrire'), findsOneWidget);
    expect(find.text('Continuer sans compte'), findsOneWidget);
    
    // Test navigation to login screen
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    
    // Verify that we're on the login screen
    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Connectez-vous pour continuer'), findsOneWidget);
  });
}

