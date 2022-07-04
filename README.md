# Microcode Compiler
Compiler for a custom microcode description format I created to make developing microcode for my CPU simulation project more enjoyable. It emits a RAM dump in the `v3.0 hex words plain` format used by [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution).

## Features
- Define aliases for signals
- Create procedures to reuse code

## Example
Microcode for an extremely rudimentary CPU. 
```
0: CPC; // Increments program counter
1: MCR; // Resets microcode offset
2: ERAM; // Puts data on address in MAR on BUS
3: LM; // Loads memory address from BUS
4: EPC; // Puts program counter on BUS
5: EIR; // Puts data of current instruction on BUS and allows microcode controller to access opcode
6: LIR; // Loads instruction from BUS
7: ERT; // Puts data from temp ALU register on internal BUS
8: LR2; // Loads data on BUS into register 2
9: LR1; // Loads data on BUS into register 1

assemblerConfig {
    instructionWidth: 16;
    opCodeWidth: 4;
}

proc fetch {
    EPC, LM;
    ERAM;
    ERAM, LIR;
    CPC;
    EIR;
}

proc reset {
    MCR;
}

ins lda {
    inline fetch;
    EIR, LM;
    ERAM;
    ERAM, LR1;
    inline reset;
}

ins add {
    inline fetch;
    EIR, LM;
    ERAM;
    ERAM, LR2;
    ; // calc
    ERT, LR1;
    inline reset;
}
```

Generated binary code:
```
v3.0 hex words plain
0018 0004 0044 0001 0020 0028 0004 0204 0002 0000 0000 0000 0000 0000 0000 0000
0018 0004 0044 0001 0020 0028 0004 0104 0000 0280 0002 0000 0000 0000 0000 0000
```


More examples can be found [here](examples). Alternatively, have a look at the syntax description which can be found [here](syntax.md).

## Download
The latest release can be downloaded fom the [releases tab](https://github.com/oskar2517/microcode-compiler/releases). Alteratively, binaries compiled from the most reason commit can be downloaded from the [actions tab](https://github.com/oskar2517/microcode-compiler/actions). 

## Usage
```
Usage: mcc [-options]

Options:
[--help | -h]          : Print this message
[--input | -i] <path>  : Specify an input file
[--output | -o] <path> : Specify an output file
```

## Syntax
Please refer to [syntax.md](syntax.md) for a description of the supported syntax.