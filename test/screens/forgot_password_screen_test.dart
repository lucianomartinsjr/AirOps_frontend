import 'package:airops_frontend/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:airops_frontend/screens/auth/forgot_password/password_reset_confirmation.dart';
import 'package:airops_frontend/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../mocks.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('ForgotPasswordScreen Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('Verifica se a tela inicial é exibida corretamente',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      expect(find.text('Recuperar Senha'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enviar'), findsWidgets);
      expect(find.text('← Retornar ao login'), findsOneWidget);
    });

    testWidgets('Verifica se o botão "Enviar" exibe o diálogo de confirmação',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.enterText(find.byType(TextField), 'user@example.com');
      await tester
          .tap(find.byType(ElevatedButton).at(0)); // Especifica o botão correto
      await tester.pumpAndSettle();

      expect(
          find.text(
              'Deseja realmente enviar uma nova senha para o email user@example.com?'),
          findsOneWidget);
    });

    testWidgets('Verifica a validação de email inválido',
        (WidgetTester tester) async {
      when(mockApiService.checkEmail('invalid@example.com'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.enterText(find.byType(TextField), 'invalid@example.com');
      await tester
          .tap(find.byType(ElevatedButton).at(0)); // Especifica o botão correto
      await tester.pumpAndSettle();

      // Simula a confirmação do diálogo
      await tester.tap(find
          .text('Enviar')
          .last); // Especifica o segundo botão "Enviar" no diálogo
      await tester.pumpAndSettle();

      expect(
          find.text('O email fornecido não está registrado.'), findsOneWidget);
    });

    testWidgets('Verifica o comportamento do envio de email com sucesso',
        (WidgetTester tester) async {
      when(mockApiService.checkEmail('user@example.com'))
          .thenAnswer((_) async => true);
      when(mockApiService.forgotPassword('user@example.com'))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.enterText(find.byType(TextField), 'user@example.com');
      await tester
          .tap(find.byType(ElevatedButton).at(0)); // Especifica o botão correto
      await tester.pumpAndSettle();

      // Simula a confirmação do diálogo
      await tester.tap(find
          .text('Enviar')
          .last); // Especifica o segundo botão "Enviar" no diálogo
      await tester.pumpAndSettle();

      expect(find.byType(PasswordResetConfirmationScreen), findsOneWidget);
    });

    testWidgets('Verifica o comportamento do envio de email com falha',
        (WidgetTester tester) async {
      when(mockApiService.checkEmail('user@example.com'))
          .thenAnswer((_) async => true);
      when(mockApiService.forgotPassword('user@example.com'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.enterText(find.byType(TextField), 'user@example.com');
      await tester
          .tap(find.byType(ElevatedButton).at(0)); // Especifica o botão correto
      await tester.pumpAndSettle();

      // Simula a confirmação do diálogo
      await tester.tap(find
          .text('Enviar')
          .last); // Especifica o segundo botão "Enviar" no diálogo
      await tester.pumpAndSettle();

      expect(
          find.text('Falha ao enviar email de recuperação.'), findsOneWidget);
    });

    testWidgets('Verifica a navegação para a tela de login',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.tap(find.text('← Retornar ao login'));
      await tester.pumpAndSettle();

      // Certifique-se de que você está realmente navegando para a tela de login
      expect(find.text('Login'), findsOneWidget);
    });
  });
}
