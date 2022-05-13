package visitor;

import ast.nodes.*;

interface Visitor {

    function visitFileNode(node:FileNode):Void;

    function visitInlineNode(node:InlineNode):Void;

    function visitInstructionNode(node:InstructionNode):Void;

    function visitMachineInsDeclarationNode(node:MachineInsDeclarationNode):Void;

    function visitProcDeclarationNode(node:ProcDeclarationNode):Void;

    function visitSignalDeclarationNode(node:SignalDeclarationNode):Void;
}