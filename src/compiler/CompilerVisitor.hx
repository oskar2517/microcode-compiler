package compiler;

import sys.io.File;
import util.Error.error;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import haxe.ds.StringMap;
import ast.nodes.*;
import visitor.Visitor;

class CompilerVisitor implements Visitor {

    final procedures:StringMap<Bytes> = new StringMap();
    final instructions:Array<Bytes> = [];
    final signals:StringMap<Int> = new StringMap();
    var instructionWidth = 0;
    var bufferOutput:BytesOutput;
    var currentMachineInsIndex = 0;

    public function new() {}

    function binaryExtend(value:Int):Int {
        final r = value % 8;
        final e = (r != 0) ? 8 - r : 0;

        return Std.int((value + e) / 8);
    }

    public function saveOutput(path:String) {
        final buffer = new StringBuf();

        buffer.add("v3.0 hex words plain\r\n");

        for (bytes in instructions) {
            var byteIndex = 0;
            for (_ in 0...Std.int(Math.pow(2, 4))) {
                if (byteIndex < bytes.length) {
                    final instruction = Bytes.alloc(instructionWidth);
                    instruction.blit(0, bytes, byteIndex, instructionWidth);
        
                    buffer.add(instruction.toHex());
                    byteIndex += instructionWidth;
                } else {
                    buffer.add("0000");
                }

                buffer.add(" ");
            }

            buffer.add("\r\n");
        }

        File.saveContent(path, buffer.toString());
    }
    
	public function visitFileNode(node:FileNode) {
        for (s in node.signalDeclarations) {
            s.accept(this);
        }

        instructionWidth = binaryExtend(node.signalDeclarations.length);

        for (p in node.procDeclarations) {
            p.accept(this);
        }

        for (i in node.machineInsDeclarations) {
            i.accept(this);
        }
    }

	public function visitInlineNode(node:InlineNode) {
        if (!procedures.exists(node.name)) {
            error('Procedure ${node.name} undefined.');
        }

        final procedure = procedures.get(node.name);

        bufferOutput.write(procedure);
    }

	public function visitInstructionNode(node:InstructionNode) {
        final instructionBytes = Bytes.alloc(instructionWidth);

        for (s in node.signals) {
            final index = signals.get(s);

            final byteIndex = instructionWidth - 1 - Std.int(index / 8);
            final byteOffset = index % 8;

            var currentData = instructionBytes.get(byteIndex);
            currentData |= 1 << byteOffset;
            
            instructionBytes.set(byteIndex, currentData);
        }

        bufferOutput.write(instructionBytes);
    }

	public function visitMachineInsDeclarationNode(node:MachineInsDeclarationNode) {
        bufferOutput = new BytesOutput();
        for (i in node.instructions) {

            i.accept(this);
        }

        instructions.push(bufferOutput.getBytes());

        currentMachineInsIndex++;
    }

	public function visitProcDeclarationNode(node:ProcDeclarationNode) {
        bufferOutput = new BytesOutput();

        for (i in node.instructions) {
            i.accept(this);
        }

        procedures.set(node.name, bufferOutput.getBytes());
    }

	public function visitSignalDeclarationNode(node:SignalDeclarationNode) {
        signals.set(node.name, node.index);
    }
}