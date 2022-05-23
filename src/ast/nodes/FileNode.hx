package ast.nodes;

import visitor.Visitor;

class FileNode extends Node {
    
    public final signalDeclarations:Array<SignalDeclarationNode> = [];
    public final procDeclarations:Array<ProcDeclarationNode> = [];
    public final machineInsDeclarations:Array<MachineInsDeclarationNode> = [];

    public function new() {
        super(File);
    }

    public function addSignalDeclaration(node:SignalDeclarationNode) {
        signalDeclarations.push(node);
    }

    public function addProcDeclaration(node:ProcDeclarationNode) {
        procDeclarations.push(node);
    }

    public function addMachineInsDeclaration(node:MachineInsDeclarationNode) {
        machineInsDeclarations.push(node);
    }

    public function accept(visitor:Visitor) {
        visitor.visitFileNode(this);
    }
}
