package build;

import haxe.macro.Expr;

private function getFormattedData() {
    final date = Date.now();

    final dd = StringTools.lpad(Std.string(date.getDate()), "0", 2);
    final mm = StringTools.lpad(Std.string(date.getMonth() + 1), "0", 2);
    final yyyy = date.getFullYear();

    return '$yyyy-$mm-$dd';
}

macro function getVersionString():Expr {
    final s = new StringBuf();

    final tag = Sys.getEnv("GITHUB_REF");
    if (tag != null) {
        s.add(tag.split("/").pop());
    } else {
        s.add("[UNKNOWN TAG]");
    }

    s.add(" ");

    final sha = Sys.getEnv("GITHUB_SHA");
    if (sha != null) {
        s.add("[");
        s.add(sha.substr(0, 7));
        s.add("]");
    } else {
        s.add("[UNKNOWN COMMIT]");
    }

    s.add(" ");

    final buildTime = getFormattedData();
    s.add("(");
    s.add(buildTime);
    s.add(")");

    return macro $v{s.toString()};
}
