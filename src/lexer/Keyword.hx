package lexer;

private final keywords = [
    "proc" => TokenType.Proc, 
    "ins" => TokenType.Ins, 
    "inline" => TokenType.Inline,
    "assemblerConfig" => TokenType.AssemblerConfig
];

function isKeyword(ident:String):Bool {
    return keywords.get(ident) != null;
}

function getKeywordType(ident:String):TokenType {
    return keywords[ident];
}
