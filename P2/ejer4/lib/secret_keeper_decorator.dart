import '../secret_keeper.dart';

abstract class SecretKeeperDecorator implements SecretKeeper {
  final SecretKeeper inner;
  SecretKeeperDecorator(this.inner);

  @override
  String get secretWord => inner.secretWord;

  @override
  Future<String> ask(String userMessage) {
    return inner.ask(userMessage);
  }
}