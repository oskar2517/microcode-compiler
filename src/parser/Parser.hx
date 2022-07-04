package parser;

import compiler.AssemblerConfig;
import ast.nodes.InlineNode;
import ast.nodes.Node;
import ast.nodes.MachineInsDeclarationNode;
import ast.nodes.ProcDeclarationNode;
import ast.nodes.InstructionNode;
import haxe.format.JsonPrinter;
import sys.io.File;
import lexer.TokenType;
import util.Error.error;
import ast.nodes.SignalDeclarationNode;
import lexer.Token;
import ast.nodes.FileNode;
import lexer.Lexer;

class Parser {

    final lexer:Lexer;
    public final ast = new FileNode();
    var currentToken:Token;
    var assemblerConfigParsed = false;

    public function new(lexer:Lexer) {
        this.lexer = lexer;

        currentToken = lexer.readToken();
    }

    function expectToken(type:TokenType) {
        if (currentToken.type != type) {
            error('Unexpected token type ${currentToken.type}, expected $type.');
        }
    }

    public function parse() {
        while (currentToken.type != Eof) {
            parseGlobal();
        }
    }

    public function writeAst() {
        File.saveContent("ast.json", JsonPrinter.print(ast));
    }

    function nextToken() {
        currentToken = lexer.readToken();
    }

    function parseSignalDeclaration():SignalDeclarationNode {
        expectToken(Number);
        final index = Std.parseInt(currentToken.literal);
        nextToken();
        expectToken(Colon);
        nextToken();
        expectToken(Ident);
        final name = currentToken.literal;
        nextToken();
        expectToken(Semicolon);
        nextToken();

        return new SignalDeclarationNode(name, index);
    }

    function parseInstruction():InstructionNode {
        final signals:Array<String> = [];

        if (currentToken.type != Semicolon) {
            while (currentToken.type != Eof) {
                expectToken(Ident);
                signals.push(currentToken.literal);
                nextToken();
                if (currentToken.type == Semicolon) {
                    break;
                }
                expectToken(Comma);
                nextToken();
            }
        }
        nextToken();

        return new InstructionNode(signals);
    }

    function parseInstructionList():Array<Node> {
        final instructions:Array<Node> = [];

        expectToken(LBrace);
        nextToken();
        while (currentToken.type != RBrace) {
            if (currentToken.type == Eof) {
                error("Unexpected end of file");
            }
            if (currentToken.type == Inline) {
                nextToken();
                expectToken(Ident);
                final name = currentToken.literal;
                nextToken();
                expectToken(Semicolon);
                nextToken();

                instructions.push(new InlineNode(name));
            } else {
                instructions.push(parseInstruction());
            }
        }
        nextToken();

        return instructions;
    }

    function parseProcDeclaration():ProcDeclarationNode {
        expectToken(Proc);
        nextToken();
        expectToken(Ident);
        final name = currentToken.literal;
        nextToken();
        final instructionList = parseInstructionList();

        return new ProcDeclarationNode(name, instructionList);
    }

    function parseMachineInsDeclaration():MachineInsDeclarationNode {
        expectToken(Ins);
        nextToken();
        expectToken(Ident);
        final name = currentToken.literal;
        nextToken();
        final instructionList = parseInstructionList();

        return new MachineInsDeclarationNode(name, instructionList);
    }

    function parseAssemblerConfig():AssemblerConfig {
        if (assemblerConfigParsed) {
            error("Assembler config section duplicated.");
        }
        assemblerConfigParsed = true;
        
        expectToken(AssemblerConfig);
        nextToken();
        expectToken(LBrace);
        nextToken();

        final assemblerConfig = ast.assemblerConfig;

        while (currentToken.type != RBrace) {
            if (currentToken.type == Eof) {
                error("Unexpected end of file");
            }
            expectToken(Ident);
            final name = currentToken.literal;
            nextToken();
            expectToken(Colon);
            nextToken();
            final value = Std.parseInt(currentToken.literal);
            if (value == null) {
                error('Could not parse value of assembler configuration entry \'$name\'.');
            }
            nextToken();
            expectToken(Semicolon);
            nextToken();

            assemblerConfig.set(name, value);
        }

        expectToken(RBrace);
        nextToken();

        return assemblerConfig;
    }

    function parseGlobal() {
        switch (currentToken.type) {
            case Number: ast.addSignalDeclaration(parseSignalDeclaration());
            case Proc: ast.addProcDeclaration(parseProcDeclaration());
            case Ins: ast.addMachineInsDeclaration(parseMachineInsDeclaration());
            case AssemblerConfig: parseAssemblerConfig();
            default: error('Unexpected token type ${currentToken.type}.');
        }
    }
}
