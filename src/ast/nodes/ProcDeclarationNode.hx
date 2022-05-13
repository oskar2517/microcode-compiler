package ast.nodes;

import visitor.Visitor;

class ProcDeclarationNode extends Node {

    public final name:String;
    public final instructions:Array<Node>;

    public function new(name:String, instructions:Array<Node>) {
        super(Proc);

        this.name = name;
        this.instructions = instructions;
    }

    public function accept(visitor:Visitor) {
        visitor.visitProcDeclarationNode(this);
    }
}