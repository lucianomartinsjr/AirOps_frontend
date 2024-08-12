import 'package:airops_frontend/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginScreen Tests', () {
    setUp(() async {
      // Limpar SharedPreferences antes de cada teste
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Verifica se os widgets principais estão presentes',
        (WidgetTester tester) async {
      // Define um tamanho de tela maior para evitar widgets fora da tela
      await tester.binding.setSurfaceSize(const Size(1080, 1920));

      // Constrói a tela de login
      await tester.pumpWidget(HookBuilder(
        builder: (context) => const MaterialApp(
          home: LoginScreen(),
        ),
      ));

      // Verifica se os elementos principais estão presentes
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Lembrar email'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('Tenta login com campos vazios e exibe erros',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle(); // Aguarda a interface atualizar

      expect(find.text('Por favor, insira seu email'), findsAny);
      expect(find.text('Por favor, insira sua senha'), findsAny);
    });

    testWidgets('Login com sucesso redireciona para home',
        (WidgetTester tester) async {
      // Define um tamanho de tela maior para evitar widgets fora da tela
      await tester.binding.setSurfaceSize(const Size(1000, 500));

      await tester.pumpWidget(HookBuilder(
        builder: (context) => const MaterialApp(
          home: LoginScreen(),
        ),
      ));

      // Preenche os campos de email e senha
      await tester.enterText(find.byType(TextField).first, 'admin@airops.com');
      await tester.enterText(find.byType(TextField).last, 'admin123');

      // Tenta realizar login
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Verifica se a navegação ocorreu para a tela de home
      expect(
          find.text('Login falhou. Verifique suas credenciais.'), findsNothing);
    });

    testWidgets('Lembra email ao fazer login', (WidgetTester tester) async {
      // Define um tamanho de tela maior para evitar widgets fora da tela
      await tester.binding.setSurfaceSize(const Size(1080, 1920));

      await tester.pumpWidget(HookBuilder(
        builder: (context) => const MaterialApp(
          home: LoginScreen(),
        ),
      ));

      // Preenche o campo de email e senha
      await tester.enterText(find.byType(TextField).first, 'admin@airops.com');
      await tester.enterText(find.byType(TextField).last, 'senha123');

      // Ativa o switch de "Lembrar email"
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Tenta realizar login
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Verifica se o email foi salvo nas preferências compartilhadas
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('savedEmail'), equals('admin@airops.com'));
    });

    testWidgets('Testa o comportamento do switch "Lembrar email"',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verifica o estado inicial do switch
      expect(find.byType(Switch), findsOneWidget);
      Switch switchWidget = tester.widget(find.byType(Switch));
      expect(switchWidget.value, isFalse);

      // Ativa o switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      switchWidget = tester.widget(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });
  });
}
