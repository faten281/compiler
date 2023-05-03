
// ignore_for_file: constant_identifier_names

enum TokenType {
  DATA_TYPE,
  IDENTIFIER,
  NUMBER,
  PLUS,
  MINUS,
  EQUALS,
  OP,
  ASTERISK,
  SLASH,
  LEFT_PAREN,
  RIGHT_PAREN,
  LEFT_BRACE,
  RIGHT_BRACE,
  SEMICOLON,
  IF,
  ELSE,
}

class Token {
  final TokenType type;
  final String lexeme;
  final int line;

  Token(this.type, this.lexeme, [this.line = 1]);

  @override
  String toString() => ' $lexeme : ${type.toString().split('.').last} ';
}
