/*
 * ==================================================================
 * GSC utility library for string manipulation, formatting, and printing support for console and entities.
 *
 * This GSC script provides easy string manipulation functions, methods and 
 * different helper functions, made for Plutonium T6 (Black Ops II)
 * ==================================================================
 * Functions:
 *  String Utilities
 *    starts_with(s, prefix)
 *    ends_with(s, suffix)
 *    replace(s, from, to)
 *    split(s, sep)
 *    join(arr, sep)
 *    strip(s)
 *    contains(s, substr)
 *    reverse(s)
 *    char_at(s, index)
 *    index_of(s, substr)
 *    capitalize(s)
 *    truncate(s, len, suffix)
 *
 *  Formatting / Printing
 *    sprintf(s, ...args)
 *    printf(s, ...args)
 *    printlnf(s, ...args)
 *    iprintf(s, ...args)
 *    iprintboldf(s, ...args)
 *
 *  Type / Conversion Helpers
 *    type(v)
 *    tokentype(s)
 *    toint(s)
 *    len(v)
 *    strlen(s)
 *    substr(s, start, end)
 *
 *  Validation Helpers
 *    is_valid_token(token)
 *    IsUInt(v)
 *    IsBoolean(v)
 *    IsColor(v)
 *    is_valid_number(v)
 * ==================================================================
 * Example Usage:
 * ```
 * #include scripts\strings;
 *
 * #define color_green "^2"
 *
 * init() {
 *   s = "hello world";
 *   if (starts_with(s, "hello")) {
 *       printlnf("Starts correctly");
 *   }
 *
 *   s = replace(s, "world", "universe");
 *   printlnf("Modified string: %s", s); // prints: "hello universe"
 *
 *   parts = split("a;b;c", ";");
 *   printlnf("Parts: %a", parts); // prints: ["a", "b", "c"]
 *   
 *   level thread onPlayerConnect();
 *
 * onPlayerConnect() {
 *    level endon("game_ended");
 *    for(;;) {
 *       level waittill("connected", player);
 *       printlnf("Player connected: %s %c(guid: %d)", player.name, color_green, player.guid);
 *       player iprintboldf("Hello, %s!", player.name);
 *    }
 * ```
 * ==================================================================
 */

#define string_t "s"
#define integer_t "d"
#define uinteger_t "u"
#define boolean_t "t"
#define float_t "f"
#define array_t "a"
#define color_t "c"

/*
 * starts_with() Checks if a string starts with a specific prefix
 * 
 * Params:
 *   s      - The string to check
 *   prefix - The prefix to look for
 *
 * Returns:
 *    true if the string starts with the prefix, false otherwise
 *
 * Example Usage:
 * ```
 * s = "Hello, world!";
 * print(starts_with(s, "Hello")); // prints: 1 (true)
 * ```
 */
starts_with(s, prefix) {
    return substr(s, 0, strlen(prefix)) == prefix;
}

/*
 * ends_with() Checks if a string ends with a specific suffix
 *
 * Params:
 *   s      - The string to check
 *   suffix - The suffix to look for
 *
 * Returns:
 *    true if the string ends with the suffix, false otherwise
 *
 * Example Usage:
 * ```
 * s = "Hello, world!";
 * print(ends_with(s, "!")); // prints: 1 (true)
 * ```
 */
ends_with(s, suffix) {
    return substr(s, strlen(s) - strlen(suffix), strlen(s)) == suffix;
}

/*
 * replace() Replaces all occurrences of a substring with another substring
 *
 * Params:
 *   s    - The string to modify
 *   from - The substring to replace
 *   to   - The substring to replace with
 *
 * Returns:
 *    The modified string
 *
 * Example usage:
 * ```
 * s = "hello world";
 * s = replace(s, "world", "universe");
 * print(s); // prints: hello universe
 * ```
 */
replace(s, from, to) {
    new = "";
    
    for (i = 0; i < strlen(s); i++) {
        if (substr(s, i, i + strlen(from)) == from) {
            new += to;
            i += strlen(from) - 1;
        } else {
            new += substr(s, i, i + 1);
        }
    }
    return new;
}

/*
 * split() Splits a string into parts based on a separator
 * 
 * Params:
 *   s   - The string to split
 *   sep - The separator to split on
 *
 * Returns:
 *    A list of strings
 *
 * Example usage:
 * ```
 * s = "this;is;a;string";
 * parts = split(s, ";");
 *   
 * for (i=0; i=len(parts); i++) {
 *   print(parts[i]); // prints: thisisastring
 * }
 * ```
 */
split(s, sep) {
    parts = [];
    current = "";

    for (i = 0; i < strlen(s); i++) {
        char = substr(s, i, i + 1);
        if (char == sep) {
            parts[parts.size] = current;
            current = "";
        } else {
            current += char;
        }
    }
    parts[parts.size] = current;
    return parts;
}

/*
 * join() Joins an array of strings with a separator
 *
 * Params:
 *   arr - The array of strings to join
 *   sep - The separator to use
 *
 * Returns:
 *    The joined string
 *
 * Example Usage:
 * ```
 * arr = array("Hello", "world!");
 * s = join(arr, " ");
 * print(s); // prints: Hello world!
 * ```
 */
join(arr, sep) {
    out = "";
    for (i=0; i<len(arr); i++) {
        out += arr[i];
        if (i < len(arr) - 1) {
            out += sep;
        }
    }
    return out;
}

/*
 * strip() Removes leading and trailing whitespace from a string
 *
 * Params:
 *   s - The string to strip
 *
 * Returns:
 *    The stripmed string
 *
 * Example Usage:
 * ```
 * s = strip("  hello world  ");
 * print(s); // prints: "hello world"
 * ```
 */
strip(s) {
    start = 0;
    end = strlen(s);

    while (start < end && substr(s, start, start+1) == " ") {
        start++;
    }

    while (end > start && substr(s, end-1, end) == " ") {
        end--;
    }

    return substr(s, start, end);
}

/*
 * contains() Checks if a string contains a specific substring
 *
 * Params:
 *   s      - The string to check
 *   prefix - The substring to look for
 *
 * Returns:
 *    true if the string contains the substring, false otherwise
 *
 * Example Usage:
 * ```
 * s = "Hello, world!";
 * print(contains(s, "world")); // prints: 1 (true)
 * ```
 */
contains(s, prefix) {
    for (i=0; i<strlen(s); i++) {
        if (substr(s, i, i + strlen(prefix)) == prefix) {
            return 1;
        }
    }
    return 0;
}

/*
 * reverse() Reverses a string or array
 *
 * Params:
 *   v - The string or array to reverse
 *
 * Returns:
 *    The reversed string or array
 *
 * Example Usage:
 * ```
 * s = reverse("hello");
 * print(s); // prints: "olleh"
 *
 * arr = reverse(array("h", "e", "l", "l", "o"));
 * for (i=0; i<len(arr); i++) {
 *   print(arr[i]); // prints: "olleh"
 * }
 * ```
 */
reverse(v) {
    if (IsString(v)) {
        new = "";
        for (i = strlen(v) - 1; i >= 0; i--) {
            new += substr(v, i, i + 1);
        }
        return new;
    }

    if (IsArray(v)) {
        new = [];
        for (i = len(v) - 1; i >= 0; i--) {
            new[len(new)] = v[i];
        }
        return new;
    }

    return v;
}

/*
 * char_at() Returns the character at a specific index in a string
 *
 * Params:
 *   s     - The string to get the character from
 *   index - The index of the character to get
 *
 * Returns:
 *    The character at the specified index
 *
 * Example Usage:
 * ```
 * s = "hello";
 * print(char_at(s, 0)); // prints: "h"
 * ```
 */
char_at(s, index) {
    return substr(s, index, index + 1);
}

/*
 * index_of() Returns the index of the first occurrence of a substring in a string
 *
 * Params:
 *   s      - The string to search in
 *   prefix - The substring to search for
 *
 * Returns:
 *    The index of the first occurrence of the substring, or -1 if not found
 *
 * Example Usage:
 * ```
 * s = "hello";
 * i = index_of(s, "l");
 * print(i); // prints: 2
 * ```
 */
index_of(s, substr) {
    if (strlen(substr) == 0) {
        return -1;
    }

    for (i = 0; i <= strlen(s) - strlen(substr); i++) {
        if (substr(s, i, i + strlen(substr)) == substr) {
            return i;
        }
    }

    return -1;
}

/*
 * repeat() Repeats a string a specified number of times
 *
 * Params:
 *   s     - The string to repeat
 *   times - The number of times to repeat the string
 *
 * Returns:
 *    The repeated string
 *
 * Example Usage:
 * ```
 * s = repeat("hello ", 3);
 * print(s); // prints: "hello hello hello "
 * ```
 */
repeat(s, times) {
    new = "";
    for (i=0; i<times; i++) {
        new += s;
    }
    return new;
}

/*
 * count() Counts the number of occurrences of a substring in a string
 *
 * Params:
 *   s      - The string to search in
 *   substr - The substring to search for
 *
 * Returns:
 *    The number of occurrences of the substring
 *
 * Example Usage:
 * ```
 *   s = "hello world, hello everyone";
 *   count = count(s, "hello");
 *   print(count); // prints: 2
 * ```
 */
count(s, substr) {
    if (strlen(substr) == 0) {
        return -1;
    }

    count = 0;
    for (i = 0; i <= strlen(s) - strlen(substr); i++) {
        if (substr(s, i, i + strlen(substr)) == substr) {
            count++;
            i += strlen(substr) - 1;
        }
    }

    return count;
}

/*
 * remove() Removes all occurrences of a substring from a string
 *
 * Params:
 *   s      - The string to remove the substring from
 *   substr - The substring to remove
 *
 * Returns:
 *    The string with the substring removed
 *
 * Example Usage:
 * ```
 *   s = remove("hello world, hello everyone", "hello");
 *   print(s); // prints: " world,  everyone"
 * ```
 */
remove(s, substr) {
    if (strlen(substr) == 0) {
        return -1;
    }

    new = "";
    for (i = 0; i <= strlen(s) - strlen(substr); ) {
        if (substr(s, i, i + strlen(substr)) == substr) {
            i += strlen(substr);
        } else {
            new += substr(s, i, i + 1);
            i++;
        }
    }

    while (i < strlen(s)) {
        new += substr(s, i, i + 1);
        i++;
    }

    return new;
}

/*
 * capitalize() Converts the first character of a string to uppercase
 *
 * Params:
 *   s - The string to capitalize
 *
 * Returns:
 *    The capitalized string
 *
 * Example Usage:
 * ```
 *   s = capitalize("hello");
 *   print(s); // prints: "Hello"
 * ```
 */
capitalize(s) {
    new = "";

    new += ToUpper(substr(s, 0, 1));
    for (i = 1; i < strlen(s); i++) {
        new += s[i];
    }

    return new;
}

truncate(s, len, suffix) {
    if (s.size <= len) {
        return s;
    }

    new = "";
    for (i = 0; i < len; i++) {
        new += substr(s, i, i + 1);
    }

    return new + suffix;
}

/*
 * sprintf() Formats a string with the given arguments
 *
 * Params:
 *   s - The format string
 *   a, b, c, d, e (etc..) - The arguments to format
 *
 * Returns:
 *    The formatted string
 *
 * Supported Types:
 *   %s  ->  string
 *   %d  ->  integer
 *   %u  ->  unsigned integer
 *   %t  ->  boolean
 *   %f  ->  float
 *   %a  ->  array
 *   %c  ->  color code
 *
 * Limitations: only supports 45 arguments
 *
 * Example Usage:
 * ```
 *   sprintf("Hello, %s", "World");                        // prints: "Hello, World"
 *   sprintf("The answer is %d", -42);                     // prints: "The answer is -42"
 *   sprintf("The value is %u", 42);                       // prints: "The value is 42"
 *   sprintf("The value is %f", 3.14);                     // prints: "The value is 3.14"
 *   sprintf("The boolean value is %t", true);             // prints: "The boolean value is 1"
 *   sprintf("Hello, %a", array("w", "o", "r", "l", "d")); // prints: "Hello, world"
 *   sprintf("%cThe color is yellow", "^3");               // prints: "^3The color is yellow"
 *   sprintf("%%");                                        // prints: "%"
 * ```
 */
sprintf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1) {
    argIndex = 0;
    new = "";

    for (i = 0; i < s.size; i++) {
        char = GetSubStr(s, i, i + 1);
        if (char == "%") {
            // for printing literal %
            if (char == "%" && GetSubStr(s, i + 1, i + 2) == "%") {
                new += "%";
                i++;
                continue;
            }

            // parse the format type
            type = GetSubStr(s, i + 1, i + 2);
            if (!is_valid_token(type)) {
                new += char;
                i++;
                continue;
            }

            // get the argument
            arg = get_argument(argIndex, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1);        
            if (isdefined(arg)) {
                // check the type of the argument
                type_name = tokentype(type);
                if (type_name == "string") {
                    if (!IsString(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1string^7 got " + type(arg) + " at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    }
                } else if (type_name == "integer") {
                    if (!IsInt(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1integer^7 got " + type(arg) + " at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    }
                } else if (type_name == "unsigned integer") {
                    if (!IsUInt(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1unsigned integer^7 got" + type(arg) + "at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    }
                } else if (type_name == "boolean") {
                    if (!IsBoolean(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1boolean^7 got " + type(arg) + " at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    }
                } else if (type_name == "float") {
                    if (!IsFloat(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1float^7 got " + type(arg) + " at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    }
                } else if (type_name == "array") {
                    if (!IsArray(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1array^7 got " + type(arg) + " at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    } 
                    arg = "[" + join(arg, ",") + "]";
                } else if (type_name == "color") {
                    if (!IsColor(arg)) {
                        return "[^1error^7] you have a type mismatch (expected ^1color^7 got " + type(arg) + " at position ^1" + (i + 1) + ":" + (i + 2) + "^7)";
                    }
                } 
                new += arg;
            }
            argIndex++;
            i++;
            continue;
        }
        new += char;
    }
    return new;
}

/*
 * printf() Prints a formatted string to the console
 *
 * Params:
 *   s - The format string
 *   a, b, c, d, e (etc..) - The arguments to format
 *
 * Limitations: only supports 45 arguments

 * Example Usage:
 * ```
 *   printf("Hello, %s", "World"); // prints: Hello, World
 * ```
 */
printf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1) {
    print(sprintf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1));
}

/*
 * printlnf() Prints a formatted string to the console with a newline
 *
 * Params:
 *   s - The format string
 *   a, b, c, d, e (etc..) - The arguments to format
 *
 * Limitations: only supports 45 arguments
 *
 * Example Usage:
 * ```
 *   printlnf("Hello, %s", "World"); // prints: Hello, World\n
 * ```
 */
printlnf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1) {
    println(sprintf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1));
}

/*
 * iprintf() iprintln's a formatted string to a given entity
 * 
 * Params:
 *   s - The format string
 *   a, b, c, d, e (etc..) - The arguments to format
 *
 * Limitations: only supports 45 arguments
 *
 * Example Usage:
 * ```
 * #include scripts\strings;
 *
 * ..other code
 *
 * onPlayerConnect() {
 *   level endon("game_ended");
 *   for(;;) {
 *      level waittill("connected", player);
 *      wait 5;
 *      player iprintf("Hello, %s", player.name);
 *   }
 * ```
 */
iprintf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1) {
    iprintln(sprintf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1));
}

/*
 * iprintboldf() iprintlnbold's a formatted string to a given entity
 * 
 * Params:
 *   s - The format string
 *   a, b, c, d, e (etc..) - The arguments to format
 *
 * Limitations: only supports 45 arguments
 *
 * Example Usage:
 * ```
 * #include scripts\strings;
 *
 * ..other code
 *
 * onPlayerConnect() {
 *   level endon("game_ended");
 *   for(;;) {
 *      level waittill("connected", player);
 *      wait 5;
 *      player iprintboldf("Hello, %s", player.name);
 *   }
 * ```
 */
iprintboldf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1) {
    iprintlnbold(sprintf(s, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1));
}


/* ================ */
/* Helper Functions */
/* ================ */

// len() Returns the length of an array or list
len(v) {
    return v.size;
}

// strlen() Returns the length of a string
strlen(s) {
    return s.size;
}

// is_empty() Returns true if a string is empty
is_empty(s) {
    return s == "";
}

// substr() Returns a substring of a string
substr(s, start, end) {
    return GetSubStr(s, start, end);
}

// toint() Converts a string to an integer
toint(s) {
    i = int(s);
    if (!IsInt(i)) return undefined;
    return i;
}

// iswhitespace() Returns true if a string contains only whitespace characters
iswhitespace(c) {
    return c == " " || c == "\t" || c == "\n";
}

// tokentype() Returns the type of a token in a string
tokentype(s) {
    switch (s) {
        case string_t: return "string";
        case integer_t: return "integer";
        case uinteger_t: return "unsigned integer";
        case boolean_t: return "boolean";
        case float_t: return "float";
        case array_t: return "array";
        case color_t: return "color";
        default: return "unknown";
    }
}

// is_valid_token() Returns true if a token is valid
is_valid_token(token) {
    if (token != string_t && token != integer_t && token != uinteger_t && token != boolean_t && token != float_t && token != array_t && token != color_t) {
        return false;
    }
    return true;
}

// type() Returns the type of a variable
type(v) {
    if (!isdefined(v)) return "undefined";
    if (IsString(v)) return "string";
    if (IsArray(v)) return "array";
    if (IsBoolean(v)) return "boolean";
    if (IsUInt(v)) return "unsigned integer";
    if (IsInt(v)) return "integer";
    if (IsFloat(v)) return "float";
    if (IsColor(v)) return "color";

    return "unknown";
}

// IsUInt() Returns true if a variable is an unsigned integer
IsUInt(v) {
    if (!isdefined(v)) return false;
    if (!IsInt(v)) return false;
    if (v < 0) return false;
    return true;
}

// IsBoolean() Returns true if a variable is a boolean
IsBoolean(v) {
    if (!isdefined(v)) return false;
    if (v == 0 || v == 1) return true;
    if (!isString(v) && v != "true" && v != "false") return false;
    return true;
}

// IsColor() Returns true if a variable is a color
IsColor(v) {
    if (!isdefined(v)) return false;
    if (!IsString(v)) return false;
        
    prefix = substr(v, 0, 1);
    color  = substr(v, 1, 2);

    if (prefix == "^" && is_valid_number(color)) return true;

    return false;
}

// is_valid_number() Returns true if a string represents a valid number
is_valid_number(v) {
    switch (v) {
        case "0": return true;
        case "1": return true;
        case "2": return true;
        case "3": return true;
        case "4": return true;
        case "5": return true;
        case "6": return true;
        case "7": return true;
        case "8": return true;
        case "9": return true;
        default: return false;
    }
}

// get_argument() Returns the argument at the specified index
get_argument(index, a, b, c, d, e, f, g, h, j, k, l, m, n, o, p, q, r, t, u, v, x, y, z, a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1, q1, r1, t1, u1, v1, x1, y1, z1) {
    switch (index) {
        case 0: return a;
        case 1: return b;
        case 2: return c;
        case 3: return d;
        case 4: return e;
        case 5: return f;
        case 6: return g;
        case 7: return h;
        case 8: return j;
        case 9: return k;
        case 10: return l;
        case 11: return m;
        case 12: return n;
        case 13: return o;
        case 14: return p;
        case 15: return q;
        case 16: return r;
        case 17: return t;
        case 18: return u;
        case 19: return v;
        case 20: return x;
        case 21: return y;
        case 22: return z;
        case 23: return a1;
        case 24: return b1;
        case 25: return c1;
        case 26: return d1;
        case 27: return e1;
        case 28: return f1;
        case 29: return g1;
        case 30: return h1;
        case 31: return j1;
        case 32: return k1;
        case 33: return l1;
        case 34: return m1;
        case 35: return n1;
        case 36: return o1;
        case 37: return p1;
        case 38: return q1;
        case 39: return r1;
        case 40: return t1;
        case 41: return u1;
        case 42: return v1;
        case 43: return x1;
        case 44: return y1;
        case 45: return z1;
        default: return undefined;
    }
}