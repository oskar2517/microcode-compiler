import build.Version.getVersionString;
import hxargs.Args;
import compiler.CompilerVisitor;
import parser.Parser;
import lexer.Lexer;
import sys.io.File;

function main() {
    final config = {
        inputPath: null,
        outputPath: null,
        showHelp: false
    };

    final argumentHandler = Args.generate([
        @doc("Print this message")
        ["--help", "-h"] => function() {
            config.showHelp = true;
        },
        @doc("Print version info")
        ["--version", "-v"] => function() {
            Sys.println(getVersionString());
            Sys.exit(0);
        },
        @doc("Specify an input file")
        ["--input", "-i"] => function(path) {
            config.inputPath = path;
        },
        @doc("Specify an output file")
        ["--output", "-o"] => function(path) {
            config.outputPath = path;
        }
    ]);

    #if interp
    config.inputPath = "code.txt";
    config.outputPath = "compiled_code.txt";
    #else
    argumentHandler.parse(Sys.args());
    #end

    if (config.inputPath == null || config.outputPath == null) {
        config.showHelp = true;
    } else {
        final code = File.getContent(config.inputPath);

        final lexer = new Lexer(code);

        final parser = new Parser(lexer);
        parser.parse();

        final compiler = new CompilerVisitor();
        parser.ast.accept(compiler);
        compiler.saveOutput(config.outputPath);
    }

    if (config.showHelp) {
        Sys.println("Usage: mcc [-options]");
        Sys.println("");
        Sys.println("Options:");
        Sys.println(argumentHandler.getDoc());
        Sys.exit(0);
    }
}
