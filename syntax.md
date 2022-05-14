# Syntax
## General definitions
```ebnf
Letter = "a" | ... | "z" | "A" | ... | "Z";
Number = "0" | "1" | "2" | "4" | "5" | "6" | "7" | "8" | "9";
```

## Comments
Comments will be ignored by the compiler.
```ebnf
Comment ::= "//", { . }, NewLine
```

Examples:
```
// This is a comment
```

## Identifiers
An identifier is a name assigned to an element in a program. It has to start with either a letter or an underscore followed by an arbitrary amount of alphanumeric characrer
```ebnf
Identifier = ( Letter | "_" ) { ( Letter | Number | "_" ) };
```
Examples of valid identifiers are `myVariable`, `TeSt123`, `_2ident`, and `x`. An example of an invalid identifier is `0test`.

## Signal declaration
Signals are represented by a single bit each. To make referencing them easier, aliases can be declared.
```ebnf
SignalDefinition ::= Number,  ":", Identifier; 
```

Examples:
```
0: SUB;
1: ERAM;
2: LRAM;
```

## Blocks
Blocks encapsulate zero or more statements.
```ebnf
Block ::= "{", { Statement }, "}";
```

Examples:
```
{
    SUB;
    ERAM, LR0;
    ;
}
```

## Statements
Statements are made up off signals. Each clock, one statement is executed.
```ebnf
Statement ::= [ Identifier, { ",", Identifier } ] ";";
```

Examples:
```
SUB;
ERAM, LR0;
;
```

## Procedure
Procedures can be inlined elsewhere allowing code to be reused.
```ebnf
Procedure ::= "proc", Identifier, Block;
```

Examples:
```
proc reset {
    MCR;
}
```

## Inlining
Procedures can be inlined using the `inline` directive.
```
Inline ::= "inline", Identifier;
```

Examples:
```
inline fetch;
```

## Instruction
Instructions will be emitted in the output file. Each instruction is made up off zero or more statements.
```ebnf
Instruction ::= "ins", Identifier, Block;
```

Examples:
```
ins mao {
    inline fetch;
    ER1, LRO;
    inline reset;
}
```