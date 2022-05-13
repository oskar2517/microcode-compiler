package ast.nodes;

import visitor.Visitor;

class MachineInsDeclarationNode extends Node {

    public final name:String;
    public final instructions:Array<Node>;

    public function new(name:String, instructions:Array<Node>) {
        super(MachineInsDeclaration);

        this.name = name;
        this.instructions = instructions;
    }

    public function accept(visitor:Visitor) {
        visitor.visitMachineInsDeclarationNode(this);
    }
}