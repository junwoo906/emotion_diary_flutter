// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:emotion_diary_flutter/main.dart';

void main() {
  testWidgets('Emotion Diary app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(EmotionDiaryApp());

    // Verify that we have the main title
    expect(find.text('감정 다이어리'), findsOneWidget);
    
    // Verify that we have emotion card
    expect(find.text('오늘의 감정'), findsOneWidget);
    expect(find.text('😊 긍정적'), findsOneWidget);

    // Verify that we have action buttons
    expect(find.text('일기 쓰기'), findsOneWidget);
    expect(find.text('감정 분석'), findsOneWidget);
    
    // Verify that we have recent diary section
    expect(find.text('최근 일기'), findsOneWidget);
  });
}
