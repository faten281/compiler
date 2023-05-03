// ignore_for_file: non_constant_identifier_names

import 'package:compiler/Token.dart';
import 'package:compiler/components.dart';
import 'package:flutter/material.dart';

class CompilerScreen extends StatefulWidget {
  const CompilerScreen({Key? key}) : super(key: key);

  @override
  State<CompilerScreen> createState() => _CompilerScreenState();
}

class _CompilerScreenState extends State<CompilerScreen> {
  List<Token> tokens = [];

  final _textEditingController = TextEditingController();
  String _inputText = '';

  String tokenString = '';
  String errorMsg = '';

  bool errorExist = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff624bd4),
            title: const Text(
              'Dart Compiler',
              style: TextStyle(color: Colors.white),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.account_tree_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xff101731),
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// INPUT FIELD
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _textEditingController,
                    onChanged: (value) {
                      setState(() {
                        _inputText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Dart Code Here',
                      hintStyle: TextStyle(color: Color(0xffaaaaaa)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF624ad4)),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                /// BUTTONS
                GoBtn(onTap: () {
                  setState(() {
                    //tokenize
                    try {
                      var tokens = tokenize(_inputText);
                      tokenString = tokens
                          .map((token) =>
                              '${token.lexeme}  :   ${token.type.toString().split('.').last}')
                          .join('\n');

                      //syntax valid or not
                      try {
                        parse(tokens);
                        errorExist = false;
                        errorMsg = 'Input Syntax is valid';
                      } catch (e) {
                        errorExist = true;
                        errorMsg = 'Input syntax error: ${e.toString()}';
                      }
                    } catch (e) {
                      errorExist = true;
                      errorMsg = 'Input syntax error: ${e.toString()}';
                    }
                  });
                }),

                ClearBtn(context: context),

                /// OUTPUT VIEW
                TokenOutput(tokenString: tokenString),

                SyntaxOutput(errorMsg: errorMsg, errorExist: errorExist),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// /// Token METHOD /// ///
  List<Token> tokenize(String input) {
    var currentCharIndex = 0;
    var currentLine = 1;
    var tokens = <Token>[];

    void advance() {
      currentCharIndex++;
    }

    void addToken(TokenType type, [String? lexeme]) {
      var tokenLexeme = lexeme ?? input[currentCharIndex];
      tokens.add(Token(type, tokenLexeme, currentLine));
    }

    while (currentCharIndex < input.length) {
      var currentChar = input[currentCharIndex];

      if (RegExp(r'[a-zA-Z_]').hasMatch(currentChar)) {
        // identifier
        var lexeme = currentChar;
        while (RegExp(r'[a-zA-Z0-9_]').hasMatch(input[currentCharIndex + 1])) {
          lexeme += input[currentCharIndex + 1];
          advance();
        }
        switch (lexeme) {
          case 'if':
            addToken(TokenType.IF, lexeme);
            break;
          case 'else':
            addToken(TokenType.ELSE, lexeme);
            break;
          case 'int':
            addToken(TokenType.DATA_TYPE, lexeme);
            break;
          case 'double':
            addToken(TokenType.DATA_TYPE, lexeme);
            break;
          case 'float':
            addToken(TokenType.DATA_TYPE, lexeme);
            break;
          case 'var':
            addToken(TokenType.DATA_TYPE, lexeme);
            break;
          case 'String':
            addToken(TokenType.DATA_TYPE, lexeme);
            break;
          default:
            addToken(TokenType.IDENTIFIER, lexeme);
        }
      } else if (RegExp(r'[0-9]').hasMatch(currentChar)) {
        // number
        var lexeme = currentChar;
        while (RegExp(r'[0-9.]').hasMatch(input[currentCharIndex + 1])) {
          lexeme += input[currentCharIndex + 1];
          advance();
        }
        addToken(TokenType.NUMBER, lexeme);
      } else if (currentChar == '=') {
        addToken(TokenType.EQUALS);
      } else if (currentChar == '+') {
        addToken(TokenType.PLUS);
      } else if (currentChar == '-') {
        addToken(TokenType.MINUS);
      } else if (currentChar == '*') {
        addToken(TokenType.ASTERISK);
      } else if (currentChar == '/') {
        addToken(TokenType.SLASH);
      } else if (currentChar == '(') {
        addToken(TokenType.LEFT_PAREN);
      } else if (currentChar == ')') {
        addToken(TokenType.RIGHT_PAREN);
      } else if (currentChar == '{') {
        addToken(TokenType.LEFT_BRACE);
      } else if (currentChar == '}') {
        addToken(TokenType.RIGHT_BRACE);
      } else if (currentChar == '>') {
        addToken(TokenType.OP);
      } else if (currentChar == '<') {
        addToken(TokenType.OP);
      } else if (currentChar == ';') {
        addToken(TokenType.SEMICOLON);
      } else if (currentChar == '\n') {
        currentLine++;
      } else if (RegExp(r'\s').hasMatch(currentChar)) {
        // ignore whitespace
      } else {
        throw Exception(
            'Unexpected character $currentChar at line $currentLine');
      }

      advance();
    }

    return tokens;
  }

  /// /// PARSE METHOD /// ///
  void parse(List<Token> tokens) {
    if (tokens.isEmpty) {
      throw Exception("No tokens to parse.");
    }

    var currentTokenIndex = 0;

    void advance() {
      currentTokenIndex++;
    }

    void expect(TokenType expectedType) {
      if (currentTokenIndex >= tokens.length) {
        throw Exception(
            "Syntax error: expected $expectedType, but found end of input");
      }
      var currentToken = tokens[currentTokenIndex];
      if (currentToken.type == expectedType) {
        advance();
      } else {
        throw Exception(
            "Syntax error: expected $expectedType, but found ${currentToken.type}");
      }
    }

    void parseExpression() {
      var currentToken = tokens[currentTokenIndex];
      if (currentToken.type == TokenType.NUMBER) {
        advance();
      } else if (currentToken.type == TokenType.IDENTIFIER) {
        advance();
        if (currentTokenIndex < tokens.length &&
            tokens[currentTokenIndex].type == TokenType.EQUALS) {
          expect(TokenType.EQUALS);
          parseExpression();
        }
      } else if (currentToken.type == TokenType.LEFT_PAREN) {
        advance();
        parseExpression();
        expect(TokenType.RIGHT_PAREN);
      } else {
        throw Exception(
            "Syntax error: expected number or identifier, but found ${currentToken.type}");
      }

      while (currentTokenIndex < tokens.length) {
        if (currentToken.type == TokenType.PLUS ||
            currentToken.type == TokenType.MINUS ||
            currentToken.type == TokenType.ASTERISK ||
            currentToken.type == TokenType.SLASH ||
            currentToken.type == TokenType.OP) {
          advance();
          parseExpression();
        } else {
          break;
        }
        currentToken = tokens[currentTokenIndex];
      }
    }

    void parseStatement() {
      if (currentTokenIndex >= tokens.length) {
        return;
      }

      var currentToken = tokens[currentTokenIndex];

      if (currentToken.type == TokenType.DATA_TYPE) {
        expect(TokenType.DATA_TYPE);
        expect(TokenType.IDENTIFIER);
        if (tokens[currentTokenIndex].type == TokenType.EQUALS) {
          expect(TokenType.EQUALS);
          parseExpression();
        }
        expect(TokenType.SEMICOLON);
      } else if (currentToken.type == TokenType.IDENTIFIER) {
        expect(TokenType.IDENTIFIER);
        expect(TokenType.EQUALS);
        parseExpression();
        expect(TokenType.SEMICOLON);
      } else if (currentToken.type == TokenType.IF) {
        expect(TokenType.IF);
        expect(TokenType.LEFT_PAREN);
        expect(TokenType.IDENTIFIER);
        expect(TokenType.OP);
        expect(TokenType.NUMBER);
        expect(TokenType.RIGHT_PAREN);

        // Check for curly braces
        if (tokens[currentTokenIndex].type == TokenType.LEFT_BRACE) {
          expect(TokenType.LEFT_BRACE);
          while (currentTokenIndex < tokens.length &&
              tokens[currentTokenIndex].type != TokenType.RIGHT_BRACE) {
            parseStatement();
          }
          expect(TokenType.RIGHT_BRACE);
        } else {
          parseStatement();
        }

        // else
        if (tokens[currentTokenIndex].type == TokenType.ELSE) {
          expect(TokenType.ELSE);
          // Check for curly braces
          if (tokens[currentTokenIndex].type == TokenType.LEFT_BRACE) {
            expect(TokenType.LEFT_BRACE);
            while (currentTokenIndex < tokens.length &&
                tokens[currentTokenIndex].type != TokenType.RIGHT_BRACE) {
              parseStatement();
            }
            expect(TokenType.RIGHT_BRACE);
          } else {
            parseStatement();
          }
        }
      } else {
        throw Exception("Syntax error: unexpected token ${currentToken.type}");
      }
    }

    while (currentTokenIndex < tokens.length) {
      parseStatement();
    }
  }
}
