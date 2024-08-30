import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

void main() {
  group('Authentication Service Test', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    test('Login com sucesso', () async {
      // Configura o mock para retornar true quando as credenciais corretas são usadas
      when(mockApiService.login('admin@airops.com', 'admin123'))
          .thenAnswer((_) async => true);

      // Executa o login
      final result = await mockApiService.login('admin@airops.com', 'admin123');

      // Verifica se o resultado foi bem-sucedido
      expect(result, isTrue);

      // Verifica se o método foi chamado com os parâmetros corretos
      verify(mockApiService.login('admin@airops.com', 'admin123')).called(1);
    });

    test('Login com falha', () async {
      // Configura o mock para retornar false quando uma senha incorreta é usada
      when(mockApiService.login('admin@airops.com', 'wrongpassword'))
          .thenAnswer((_) async => false);

      // Executa o login
      final result =
          await mockApiService.login('admin@airops.com', 'wrongpassword');

      // Verifica se o resultado foi uma falha
      expect(result, isFalse);

      // Verifica se o método foi chamado com os parâmetros corretos
      verify(mockApiService.login('admin@airops.com', 'wrongpassword'))
          .called(1);
    });
  });
}
