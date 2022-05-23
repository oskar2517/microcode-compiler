package ast.nodes;

import visitor.Visitor;

class InstructionNode extends Node {
    
    public final signals:Array<String>;

    public function new(signals:Array<String>) {
        super(Instruction);

        this.signals = signals;
    }

    public function accept(visitor:Visitor) {
        visitor.visitInstructionNode(this);
    }
}
