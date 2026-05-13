/*
 * ==================================================================
 * GSC JSON library made for Plutonium t6 (Black Ops II)
 * 
 * A lightweight JSON library for Plutonium T6 (BO2) GSC, enabling 
 * easy creation, parsing, and serialization of JSON objects and arrays
 * ==================================================================
 * Dependencies:
 *   Requires the strings utility library:
 *   https://github.com/Yallamaztar/strings
 *
 *   This library relies on the following functions:
 *     - sprintf()
 *     - IsBoolean()
 *     - strlen()
 *     - len()
 *     - substr()
 *
 *   Make sure to include the strings library
 *   before using this JSON module
 * ==================================================================
 * API Reference (refer to each function implementation for detailed documentation and usage)
 *
 * File I/O API:
 *   - allow_fileIO()
 *   - write(file, data)
 *   - read(file)
 *   - _write(file, data) - "private" helper function
 *   - _read(file)        - "private" helper function
 *
 * Object API:
 *   - json_object()
 *   - object_add(obj, key, value)
 *   - object_remove(obj, key)
 *   - object_get(obj, key)
 *   - object_has(obj, key)
 *   - object_clear(obj)
 *   - object_keys(obj)
 *   - object_jsonify(obj)
 *
 * Array API:
 *   - json_array()
 *   - array_add(arr, value)
 *   - array_remove(arr, value)
 *   - array_has(arr, value)
 *   - array_clear(arr)
 *   - array_pop(arr)
 *   - array_jsonify(arr)
 *
 * Parser API:
 *   - new_parser(s)
 *   - stringify(parser)
 *
 * Parser Core:
 *   - parse_object(p)
 *   - parse_array(p)
 *   - parse_string(p)
 *   - parse_number(p)
 *   - parse_boolean(p)
 *
 * Serialization (helpers):
 *   - json_stringify_value(v)
 *   - json_kv(key, value)
 *
 * Utility Functions:
 *   - consume(p, expected)
 *   - skip_whitespaces(p)
 *   - get_current_char(p)
 * ==================================================================
 * Example Usage:
 * ```
 * init() {
 *   // create a player object
 *   player = json_object();
 *
 *   // add properties to the player object
 *   player = object_add(player, "name", "Alex");
 *   player = object_add(player, "age", 22);
 *   player = object_add(player, "admin", false);
 *
 *   // create nested array
 *   scores = json_array();
 *
 *   // add values to the scores array
 *   scores = array_add(scores, 10);
 *   scores = array_add(scores, 25);
 *   scores = array_add(scores, 99);
 *
 *   // add the array to the player object
 *   player = object_add(player, "scores", scores);
 *
 *   // jsonify the player object
 *   json = object_jsonify(player);
 *
 *   printlnf("^2Generated JSON:^7 %s", json); 
 *   // Generated JSON: {"name":"Alex","age":22,"admin":false,"scores":[10,25,99]}
 *  
 *   // file I/O example (write and reading)
 *   write("player.json", player);
 *   loaded = read("player.json");
 *  
 *   printlnf("^3Loaded name:^7 %s", loaded["name"]);
 *   printlnf("^3Loaded age:^7 %d", loaded["age"]);
 *   printlnf("^3Loaded admin:^7 %t", loaded["admin"]);
 *   printlnf("^3Loaded scores:^7 %a", loaded["scores"]);
 *
 *   // parse back to JSON
 *   parser = new_parser(json);
 *   parsed = stringify(parser);
 *
 *   printlnf("^3Parsed name:^7 %s", parsed["name"]);     // Alex
 *   printlnf("^3Parsed age:^7 %d", parsed["age"]);       // 22
 *   printlnf("^3Parsed admin:^7 %t", parsed["admin"]);   // 0 
 *   printlnf("^3Parsed scores:^7 %a", parsed["scores"]); // [10,25,99]
 * }
 *
 * // required for using file I/O functions
 * allow_fileIO(); 
 *
 * // write JSON object to file
 * write("players.json", player);
 *
 * // read JSON object back from file (auto parsed)
 * data = read("players.json");
 *
 * printlnf("[players.json] name: %s", data["name"]);      // Alex
 * printlnf("[players.json] age: %d", data["age"]);        // 22
 * printlnf("[players.json] is admin: %t", data["admin"]); // 0 -> booleans are represented by: 0 (false) | 1 (true)
 * printlnf("[players.json] scores: %a", data["scores"]);  // [10,25,99]
 * ```
 */
 
#include scripts\strings;

#define null undefined

/* Object API macros */
#define json_obj() json_object()
#define obj_add(obj, key, value) object_add(obj, key, value)
#define obj_remove(obj, key) object_remove(obj, key)
#define obj_get(obj, key) object_get(obj, key)
#define obj_has(obj, key) object_has(obj, key)
#define obj_clear(obj) object_clear(obj)
#define obj_keys(obj) object_keys(obj)
#define obj_jsonify(obj) object_jsonify(obj)

/* Array API macros */
#define json_arr() json_array()
#define array_push(arr, value) array_add(arr, value)
#define arr_add(arr, value) array_add(arr, value)
#define arr_remove(arr, value) array_remove(arr, value)
#define arr_has(arr, value) array_has(arr, value)
#define arr_clear(arr) array_clear(arr)
#define arr_pop(arr) array_pop(arr)
#define arr_jsonify(arr) array_jsonify(arr)

/*
 * allow_fileIO() Enables file I/O operations
 *
 * Example Usage:
 * ```
 * init() {
 *   allow_fileIO();
 * }
 * ```
 */
allow_fileIO() {
    SetDvar("scr_allowFileIo", "1");
}

/*
 * write(file, obj) Writes a JSON object to a file
 *
 * Params:
 *   file - The file to write to
 *   obj  - The JSON object to write
 *
 * Returns:
 *   true if the write was successful, false otherwise
 *
 * Example Usage:
 * ```
 * player = json_object();
 * write("player.json", player);
 * ```
 */
write(file, obj) {
    json = object_jsonify(obj);

    if (!isdefined(json)) {
        return false;
    }

    return _write(file, json);
}

// _write(file, data) Writes a JSON string to a file
_write(file, data) {
    if (!isdefined(file) || !isdefined(data)) {
        return false;
    }
    
    fs = fs_fopen(file, "write");
    if (!isdefined(fs)) {
        return false;
    }

    // ensure string conversion
    fs_writeline(fs, "" + data);

    fs_fclose(fs);
    return true;
}

/*
 * read(file) Reads a JSON object from a file
 *
 * Params:
 *   file - The file to read from
 *
 * Returns:
 *   The JSON object read from the file, or null if the read was unsuccessful
 *
 * Example Usage:
 * ```
 * player = read("player.json");
 * ```
 */
read(file) {
    data = _read(file);
    if (!isdefined(data)) {
        return null;
    }

    p = new_parser(data);
    return stringify(p);
}

// _read(file) Read a JSON string from a file
_read(file) {
    if (!isdefined(file) || !fs_testfile(file)) {
        return null;
    }

    fs = fs_fopen(file, "read");
    if (!isdefined(fs)) {
        return null;
    }

    data = "";
    first = true;

    while (true) {
        line = fs_readline(fs);

        if (!isdefined(line)) {
            break;
        }

        if (!first) {
            data += "\n";
        }

        data += line;
        first = false;
    }

    fs_fclose(fs);

    if (data == "") {
        return null;
    }

    return data;
}

print_json(file)
{
    data = _read(file);

    if (!isdefined(data))
    {
        println("^1Error:^7 Failed to read file");
        return;
    }

    parser = new_parser(data);
    parsed = stringify(parser);

    if (!isdefined(parsed))
    {
        println("^1Error:^7 Failed to parse JSON");
        return;
    }

    json = object_jsonify(parsed);

    printlnf("^2Parsed:^7 %s", json);
}

/* 
 * json_object() Returns a new JSON object
 *
 * Returns:
 *   A new JSON object
 *
 * Example Usage:
 * ```
 * obj = json_object();
 * ```
 */
json_object() {
    return [];
}

/* 
 * object_add(obj, key, value) Adds a key-value pair to a JSON object
 *
 * Params:
 *   obj   - The JSON object to add the key-value pair to
 *   key   - The key for the new pair
 *   value - The value for the new pair
 *
 * Returns:
 *   The updated JSON object
 *
 * Example Usage:
 * ```
 * obj = object_add(obj, "key", "value");
 * ```
 */
object_add(obj, key, value) {
    if (!isdefined(obj) || !isdefined(key) || !isdefined(value)) {
        return null;
    }

    obj[obj.size] = json_kv(key, value);
    return obj;
}

/*
 * object_remove(obj, key) Removes a key-value pair from a JSON object
 *
 * Params:
 *   obj - The JSON object to remove the key-value pair from
 *   key - The key of the pair to remove
 *
 * Returns:
 *   The updated JSON object
 *
 * Example Usage:
 * ```
 * obj = object_remove(obj, "key");
 * ```
 */
object_remove(obj, key) {
    if (!isdefined(obj) || !isdefined(key)) {
        return null;
    }

    new = json_object();
    for (i = 0; i < len(obj); i++) {
        if (obj[i]["key"] != key) {
            new = object_add(new, obj[i]["key"], obj[i]["value"]);
        }
    }
    return new;
}

/*
 * object_get(obj, key) Gets the value associated with a key in a JSON object
 *
 * Params:
 *   obj - The JSON object to search
 *   key - The key to look for
 *
 * Returns:
 *   The value associated with the key, or null if not found
 *
 * Example Usage:
 * ```
 * value = object_get(obj, "key");
 * ```
 */
object_get(obj, key) {
    if (!isdefined(obj) || !isdefined(key)) {
        return null;
    }

    for (i = 0; i < len(obj); i++) {
        if (obj[i]["key"] == key) {
            return obj[i]["value"];
        }
    }
    return null;
}

/*
 * object_has(obj, key) Checks if a key exists in a JSON object
 *
 * Params:
 *   obj - The JSON object to search
 *   key - The key to look for
 *
 * Returns:
 *   true if the key exists, false otherwise
 *
 * Example Usage:
 * ```
 * hasKey = object_has(obj, "key");
 * ```
 */
object_has(obj, key) {
    if (!isdefined(obj) || !isdefined(key)) {
        return false;
    }

    for (i = 0; i < len(obj); i++) {
        if (obj[i]["key"] == key) {
            return true;
        }
    }
    return false;
}

/*
 * object_clear(obj) Clears a JSON object
 *
 * Params:
 *   obj - The JSON object to clear
 *
 * Returns:
 *   An empty JSON object
 *
 * Example Usage:
 * ```
 * obj = object_clear(obj);
 * ```
 */
object_clear(obj) {
    obj = json_object();
    return obj;
}

/*
 * object_keys(obj) Returns a json array of all keys
 *
 * Params:
 *   obj - The JSON object to get keys from
 *
 * Returns:
 *   A json array of all keys in the object
 *
 * Example Usage:
 * ```
 * keys = object_keys(obj);
 * ```
 */
object_keys(obj) {
    if (!isdefined(obj)) {
        return null;
    }

    keys = json_array();
    for (i = 0; i < len(obj); i++) {
        keys = array_add(keys, obj[i]["key"]);
    }
    return keys;
}

/*
 * object_jsonify(obj) Converts a JSON object to its string representation
 *
 * Params:
 *   obj - The JSON object to convert
 *
 * Returns:
 *   The JSON string representation of the object
 *
 * Example Usage:
 * ```
 * json = object_jsonify(obj);
 * ```
 */
object_jsonify(obj) {
    if (!isdefined(obj) || len(obj) == 0) {
        return null;
    }

    json = "{";
    for (i = 0; i < len(obj); i++) {
        kv = obj[i];
        json += sprintf("\"%s\":%s", kv["key"], json_stringify_value(kv["value"]));

        if (i < len(obj) - 1) {
            json += ",";
        }
    }
    
    json += "}";
    return json;
}

/* 
 * json_array() Returns a new JSON array
 *
 * Returns:
 *   A new JSON array
 *
 * Example Usage:
 * ```
 * arr = json_array();
 * ```
 */
json_array() {
    return [];
}

/* 
 * array_add(arr, value) Adds a value to a JSON array
 *
 * Params:
 *   arr   - The JSON array to add the value to
 *   value - The value to add
 *
 * Returns:
 *   The updated JSON array
 *
 * Example Usage:
 * ```
 * arr = array_add(arr, "value");
 * ```
 */
array_add(arr, value) {
    if (!isdefined(arr) || !isdefined(value)) {
        return null;
    }

    arr[arr.size] = value;
    return arr;
}

/*
 * array_remove(arr, value) Removes a value from a JSON array
 *
 * Params:
 *   arr   - The JSON array to remove the value from
 *   value - The value to remove
 *
 * Returns:
 *   The updated JSON array
 *
 * Example Usage:
 * ```
 * arr = array_remove(arr, "value");
 * ```
 */
array_remove(arr, value) {
    if (!isdefined(arr) || !isdefined(value)) {
        return null;
    }

    new = json_array();
    for (i = 0; i < len(arr); i++) {
        if (arr[i] != value) {
            new = array_add(new, arr[i]);
        }
    }
    return new;
}

/*
 * array_has(arr, value) Checks if a value exists in a JSON array
 *
 * Params:
 *   arr   - The JSON array to search
 *   value - The value to look for
 *
 * Returns:
 *   true if the value exists, false otherwise
 *
 * Example Usage:
 * ```
 * hasValue = array_has(arr, "value");
 * ```
 */
array_has(arr, value) {
    if (!isdefined(arr) || !isdefined(value)) {
        return false;
    }

    for (i = 0; i < len(arr); i++) {
        if (arr[i] == value) {
            return true;
        }
    }
    return false;
}

/*
 * array_clear(arr) Clears a JSON array
 *
 * Params:
 *   arr - The JSON array to clear
 *
 * Returns:
 *   An empty JSON array
 *
 * Example Usage:
 * ```
 * arr = array_clear(arr);
 * ```
 */
array_clear(arr) {
    arr = json_array();
    return arr;
}

/*
 * array_pop(arr) Removes the last element from a JSON array
 *
 * Params:
 *   arr - The JSON array to pop from
 *
 * Returns:
 *   The JSON array with the last element removed
 *
 * Example Usage:
 * ```
 * arr = array_pop(arr);
 * ```
 */
array_pop(arr) {
    if (!isdefined(arr) || len(arr) == 0) {
        return null;
    }

    new = json_array();
    for (i = 0; i < len(arr) - 1; i++) {
        new = array_add(new, arr[i]);
    }
    return new;
}

/*
 * array_jsonify(arr) Converts a JSON array to its string representation
 *
 * Params:
 *   arr - The JSON array to convert
 *
 * Returns:
 *   The JSON string representation of the array
 *
 * Example Usage:
 * ```
 * json = array_jsonify(arr);
 * ```
 */
array_jsonify(arr) {
    if (!isdefined(arr) || len(arr) == 0) {
        return null;
    }

    json = "[";
    for (i = 0; i < arr.size; i++) {
        json += json_stringify_value(arr[i]);
        if (i < arr.size - 1) {
            json += ",";
        }
    }
    json += "]";
    return json;
}

/*
 * new_parser(s) Returns a new JSON parser
 *
 * Params:
 *   s - The JSON string to parse
 *
 * Returns:
 *   A new JSON parser instance
 *
 * Example Usage:
 * ```
 * json_string = "{\"name\":\"Alex\",\"age\":22}";
 * parser = new_parser(json_string);
 * ```
 */
new_parser(s) {
    if (!isdefined(s)) {
        println("Invalid JSON string");
        return null;
    }

    p = SpawnStruct();
    p.index  = 0;
    p.string = s;
    return p;
}

/*
 * stringify(parser) Returns the parsed JSON data
 *
 * Params:
 *   parser - The JSON parser instance
 *
 * Returns:
 *   The parsed JSON data
 *
 * Example Usage:
 * ```
 * json_string = "{\"name\":\"Alex\",\"age\":22}";
 * parser = new_parser(json_string);
 * data = stringify(parser);
 * ```
 */
stringify(parser) {
    if (!isdefined(parser) || parser.string == "") {
        return null;
    }

    skip_whitespaces(parser);

    char = get_current_char(parser);
    if (!isdefined(char)) {
        return null;
    }

    switch (char) {
        case "{":
            return parse_object(parser);

        case "[":
            return parse_array(parser);

        case "\"":
            return parse_string(parser);

        case "-":
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
            return parse_number(parser);

        default:
            return parse_boolean(parser);
    }
}

// parse_object(p) Parses a JSON object
parse_object(p) {
    obj = json_object();
    
    consume(p, "{");
    skip_whitespaces(p);

    if (p.index >= strlen(p.string)) {
        return null;
    }

    if (get_current_char(p) == "}") {
        consume(p, "}");
        return obj;
    }

    for (;;) {
        skip_whitespaces(p);
        key = parse_string(p);
        if (!isdefined(key)) {
            return null;
        }

        skip_whitespaces(p);

        result = consume(p, ":");
        if (!isdefined(result)) {
            return null;
        }

        skip_whitespaces(p);

        value = stringify(p);
        if (!isdefined(value) && value != false) {
            return null;
        }

        obj = object_add(obj, key, value);
        skip_whitespaces(p);

        char = get_current_char(p);
        if (char == ",") {
            consume(p, ",");
            continue;
        }

        // end object
        if (char == "}") {
            consume(p, "}");
            break;
        }

        return null;
    }

    return obj;
}

// parse_string(p) Parses a JSON string
parse_string(p) {
    consume(p, "\"");
    parsed = "";

    while (p.index < strlen(p.string)) {
        char = get_current_char(p);

        // end string
        if (char == "\"") {
            consume(p, "\"");
            return parsed;
        }

        // escaped chars
        if (char == "\\") {
            p.index++;
            
            escaped = get_current_char(p);
            switch (escaped) {
                case "\"":
                    parsed += "\"";
                    break;
                case "\\":
                    parsed += "\\";
                    break;
                case "/":
                    parsed += "/";
                    break;
                case "b":
                    parsed += "\b";
                    break;
                case "f":
                    parsed += "\f";
                    break;
                case "n":
                    parsed += "\n";
                    break;
                case "r":
                    parsed += "\r";
                    break;
                case "t":
                    parsed += "\t";
                    break;
                default:
                    parsed += escaped;
                    break;
            }

            p.index++;
            continue;
        }
        parsed += char;
        p.index++;
    }

    return null;
}

// parse_array(p) Parses a JSON array
parse_array(p) {
    arr = json_array();
    consume(p, "[");
    skip_whitespaces(p);

    if (p.index >= strlen(p.string)) {
        return null;
    }

    if (get_current_char(p) == "]") {
        consume(p, "]");
        return arr;
    }

    for (;;) {
        skip_whitespaces(p);
        value = stringify(p);
        if (!isdefined(value) && value != false) {
            return null;
        }

        arr = array_add(arr, value);
        skip_whitespaces(p);

        char = get_current_char(p);
        if (char == ",") {
            consume(p, ",");
            continue;
        }

        // end array
        if (char == "]") {
            consume(p, "]");
            break;
        }

        return null;
    }

    return arr;
}

// parse_number(p) Parses a JSON number
parse_number(p) {
    num = "";
    while (p.index < strlen(p.string)) {
        char = get_current_char(p);
        if (char != "-" && char != "." && (char < "0" || char > "9")) {
            break;
        }
        num += char;
        p.index++;
    }
    return int(num);
}

// parse_boolean(p) Parses a JSON boolean
parse_boolean(p) {
    if (substr(p.string, p.index, p.index + 4) == "true") {
        p.index += 4;
        return true;
    }

    if (substr(p.string, p.index, p.index + 5) == "false") {
        p.index += 5;
        return false;
    }

    if (substr(p.string, p.index, p.index + 4) == "null") {
        p.index += 4;
        return null;
    }

    return null;
}

/*
 * json_stringify_value(v) Converts a value to its JSON string representation
 *
 * Params:
 *   v - The value to convert
 *
 * Returns:
 *   The JSON string representation of the value
 *
 * Example Usage:
 * ```
 * json = json_stringify_value("Hello, World!");
 * ```
 */
json_stringify_value(v) {
    if (!isdefined(v)) {
        return "null";
    }

    if (IsString(v)) {
        return "\"" + v + "\"";
    }

    if (IsArray(v)) {
        keys = getArrayKeys(v);
        isObject = false;
        for (i = 0; i < keys.size; i++) {
            if (IsString(keys[i])) {
                isObject = true;
                break;
            }
        }
        if (isObject) {
            return object_jsonify(v);
        }
        
        json = "[";
        for (i = 0; i < keys.size; i++) {
            json += json_stringify_value(v[keys[i]]);
            if (i < keys.size - 1) json += ",";
        }
        json += "]";
        return json;
    }  

    if (IsBoolean(v) && !IsInt(v) && !IsFloat(v)) {
        if (v) return "true";
        return "false";
    }


    if (IsVec(v)) {
        json = "[";
        first = true;

        for (i = 0; i < 3; i++) {
            if (isdefined(v[i])) {
                if (!first) { 
                    json += ",";
                }

                json += json_stringify_value(v[i]);
                first = false;
            }
        }

        json += "]";
        return json;
    }

    if (!isdefined(v)) {
        return "null";
    }

    return "" + v;
}


// json_kv(key, value) Returns a new key-value pair for a JSON object
json_kv(key, value) {
    if (!isdefined(key) || !isdefined(value)) {
        return null;
    }

    kv = [];
    kv["key"] = key;
    kv["value"] = value;
    return kv;
}

// consume(p, expected) Consumes the expected character from the parser
consume(p, expected) {
    char = get_current_char(p);
    if (char != expected) {
        return null;
    }
    p.index++;
    return char;
}

// skip_whitespaces(p) Skips whitespace characters in the parser
skip_whitespaces(p) {
    while (p.index < strlen(p.string)) {
        char = p.string[p.index];
        if (char != " " && char != "\t" && char != "\n" && char != "\r") {
            break;
        }
        p.index++;
    }
}

// get_current_char(p) Returns the current character from the parser
get_current_char(p) {
    return p.string[p.index];
}
