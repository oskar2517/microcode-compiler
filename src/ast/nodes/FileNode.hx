package ast.nodes;

import compiler.AssemblerConfig;
import visitor.Visitor;

class FileNode extends Node {
    
    public final signalDeclarations:Array<SignalDeclarationNode> = [];
    public final procDeclarations:Array<ProcDeclarationNode> = [];
    public final machineInsDeclarations:Array<MachineInsDeclarationNode> = [];
    public final assemblerConfig = new AssemblerConfig();

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
