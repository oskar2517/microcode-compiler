package compiler;

import haxe.ds.StringMap;
import haxe.Json;

typedef OpCode = {
    mnemonic:String,
    address:Int
}

class AssemblerConfig {

    private final config:StringMap<Any> = new StringMap();

    public function new() {}

    public function set(key:String, value:Any) {
        config.set(key, value);
    }

    @:generic
    public function get<T>(key:String):T {
        return config.get(key);
    }

    @:generic
    public function getOrDefault<T>(key:String, def:T):T {
        return if (config.exists(key)) {
            config.get(key);
        } else {
            def;
        }
    }

    public function encode():String {
        return Json.stringify(config);
    }
}