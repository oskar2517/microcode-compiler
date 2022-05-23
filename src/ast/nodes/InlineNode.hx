package ast.nodes;

import visitor.Visitor;

class InlineNode extends Node {
    
    public final name:String;

    public function new(name:String) {
        super(Inline);

        this.name = name;
    }

    public function accept(visitor:Visitor) {
        visitor.visitInlineNode(this);
    }
}
