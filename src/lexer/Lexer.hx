package lexer;

import lexer.Keyword.getKeywordType;
import lexer.Keyword.isKeyword;
import lexer.LexerHelper.isLinebreak;
import lexer.LexerHelper.isNumber;
import lexer.LexerHelper.isAscii;

class Lexer {
    
    private final code:String;
    var currentChar = " ";
    var position = 0;

    public function new(code:String) {
        this.code = code;
    }

    function readChar() {
        currentChar = if (position >= code.length) {
            "\u{0}";
        } else {
            code.charAt(position);
        }

        position++;

        eatComment();
    }

    function peekChar():String {
        return (position >= code.length) ? "\u{0}" : code.charAt(position);
    }

    function readIdent():String {
        final startPosition = position;

        while (isAscii(peekChar()) || peekChar() == "_") {
            readChar();
        }

        return code.substring(startPosition - 1, position);
    }

    function readNumber():String {
        final startPosition = position;

        while (isNumber(peekChar())) {
            readChar();
        }

        return code.substring(startPosition - 1, position);
    }

    function eatWhitespace() {
        while (currentChar == " " || isLinebreak(currentChar) || currentChar == "\t") {
            readChar();
        }
    }

    function eatComment() {
        if (currentChar == "/" && peekChar() == "/") {
            while (!isLinebreak(currentChar) && currentChar != "\u{0}") {
                readChar();
            }
        }
    }

    public function tokenize() {
        while (currentChar != "\u{0}") {
            final token = readToken();
            trace(token.toString());
        }
    }

    public function readToken():Token {
        readChar();
        eatWhitespace();

        return switch (currentChar) {
            case ":": new Token(Colon, currentChar);
            case ";": new Token(Semicolon, currentChar);
            case ",": new Token(Comma, currentChar);
            case "{": new Token(LBrace, currentChar);
            case "}": new Token(RBrace, currentChar);
            case "\u{0}": new Token(Eof, currentChar);
            default:
                if (isNumber(currentChar)) {
                    final number = readNumber();
                    return new Token(Number, number);
                }

                if (isAscii(currentChar)) {
                    final ident = readIdent();

                    return if (isKeyword(ident)) {
                        new Token(getKeywordType(ident), ident);
                    } else {
                        new Token(Ident, ident);
                    }
                }

                return new Token(Illegal, currentChar);
        }
    }
}
