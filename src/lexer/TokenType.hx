package lexer;

enum TokenType {
    Illegal;
    Eof;

    Colon;
    Semicolon;
    Comma;
    LBrace;
    RBrace;

    Proc;
    Ins;
    Inline;

    Ident;
    Number;
}