package ast.nodes;

import visitor.Visitor;

class SignalDeclarationNode extends Node {
    
    public final name:String;
    public final index:Int;

    public function new(name:String, index:Int) {
        super(SignalDeclaration);

        this.name = name;
        this.index = index;
    }

    public function accept(visitor:Visitor) {
        visitor.visitSignalDeclarationNode(this);
    }
}