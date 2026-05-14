/*
 * JSON based HUD creation and management system for Plutonium T6
 * Very work in progress still, all properties dont even work still
 *
 * Contributions are welcome
 * ================================================================
 * Dependencies:
 *   Requires the strings utility library:
 *   https://github.com/Yallamaztar/strings
 *
 *   This library relies on the following functions:
 *     - printlnf()
 *     - len()
 *   ------------------------------------------------
 *   Requires the JSON library:
 *   https://github.com/Yallamaztar/JSON
 *
 *   This library relies on the following functions:
 *     - read()
 *     - json_object()
 *     - object_keys()
 *     - object_get()
 *     - object_add()
 *     - json_array()
 *     - array_add()
 *
 *   Make sure to have these scripts in your
 *   scripts\ dir before using this HUD script
 * ================================================================
 * Currently supported HUD elements:
 *    - ClientHudElement
 *    - ServerFontString
 *
 * Currently supported properties:
 *    - hud_x(hud, x)
 *    - hud_y(hud, y)
 *    - hud_setText(hud, text)
 *    - hud_setPoint(hud, x, y, width, height)
 *    - hud_setShader(hud, shader, r, g, b)
 *    - hud_alignX(hud, alignX)
 *    - hud_alignY(hud, alignY)
 *    - hud_horzalign(hud, horzalign)
 *    - hud_vertalign(hud, value)
 *    - hud_font(hud, font)
 *    - hud_fontScale(hud, fontScale)
 *    - hud_color(hud, color)
 *    - hud_alpha(hud, alpha)
 *    - hud_glowColor(hud, glowColor)
 *    - hud_glowAlpha(hud, glowAlpha)
 *    - hud_sort(hud, sort)
 *    - hud_foreground(hud, foreground)
 *    - hud_hidewhendead(hud, state)
 *    - hud_hidewhenindemo(hud, state)
 *    - hud_hidewheninkillcam(hud, state)
 *    - hud_hidewheninmenu(hud, state)
 *    - hud_moveOvertime(hud, overtime)
 *    - hud_fadeOverTime(hud, overtime)
 *    - hud_setPulseFX(hud, speed, decaystart, decayduration)
 */

#include maps\mp\gametypes\_hud_util;
#include scripts\strings;
#include scripts\json;

/*
 * hud_load(file, entity) Loads a HUD element from a JSON file
 *
 * Params:
 *    file   - The path to the JSON file
 *    entity - The entity for which to create the HUD element (optional)
 *
 * Returns:
 *    The loaded HUD element 
 *
 * Example Usage:
 * ```
 * onPlayerConnect() {
 *   for(;;) {
 *     level waittill("connected", player);
 *     player.welcome_text = hud_load("hud.json");
 *     player.menu = hud_load("menu.json", player);
 *   }
 * }
 * ```
 */
hud_load(file, entity) {
    if (isdefined(entity)) {
        return _load_hud_element(file, entity);
    } else {    
        return _load_server_string(file);
    }
}

/*
 * _load_hud_element(file, entity) Loads a HUD element from a JSON file
 *
 * Params:
 *    file   - The path to the JSON file
 *    entity - The entity for which to create the HUD element (optional)
 *
 * Example Usage:
 * ```
 * onPlayerConnect() {
 *   for(;;) {
 *     level waittill("connected", player);
 *     player.welcome_text = _load_hud_element("hud.json", player);
 *   }
 * }
 * ```
 */
_load_hud_element(file, entity) {
    json = read(file);

    if (!isdefined(json)) {
        printlnf("^1Error:^7 Failed to read JSON file: %s", file);
        return undefined;
    }

    // Create the HUD element
    hud = hud_client_hud_element(entity);

    // Apply each property from the json to the hud element 
    keys = object_keys(json);
    for (i = 0; i < len(keys); i++) {
        printlnf("Applying property: %s", keys[i]);
        hud = _apply_property(hud, keys[i], object_get(json, keys[i]));
    }
}

/*
 * _load_server_string(file) Loads a server string from a JSON file
 *
 * Params:
 *    file - The path to the JSON file
 *
 * Returns:
 *    The loaded server string
 *
 * Example Usage:
 * ```
 * onPlayerConnect() {
 *   for(;;) {
 *     level waittill("connected", player);
 *     player.welcome_text = _load_server_string("hud.json");
 *   }
 * }
 * ```
 */
_load_server_string(file) {
    data = read(file);
    if (!isdefined(data)) {
        printlnf("^1Error:^7 Failed to read JSON file: %s", file);
        return undefined;
    }

    // Create the server font string
    str = hud_server_font_string(object_get(data, "font"), object_get(data, "fontScale"));

    // Apply each property from the json to the server font string
    keys = object_keys(data);
    for (i = 0; i < len(keys); i++) {
        printlnf("Applying property: %s", keys[i]);
        str = _apply_property(str, keys[i], object_get(data, keys[i]));
    }
}

/*
 * _apply_property(hud, key, value) Applies a property to a HUD element
 *
 * Params:
 *    hud   - The HUD element to which to apply the property
 *    key   - The property name
 *    value - The property value
 *
 * Returns:
 *    The updated HUD element
 */
_apply_property(hud, key, value) {
    switch (key) {
        case "setText": return hud_setText(hud, value);
        case "setShader":
            return hud_setShader(hud, value[0], value[1], value[2]);
        case "setPoint": 
            return hud_setPoint(hud, value[0], value[1], int(value[2]), int(value[3]));
        
        case "x": return hud_x(hud, value);
        case "y": return hud_y(hud, value);
        
        case "alignX": return hud_alignX(hud, value);
        case "alignY": return hud_alignY(hud, value);
        case "horzalign": return hud_horzalign(hud, value);

        case "font": return hud_font(hud, value);
        case "fontScale": return hud_fontScale(hud, value);
        
        case "color": return hud_color(hud, value);
        case "alpha": return hud_alpha(hud, value);
        case "sort": return hud_sort(hud, value);
        case "foreground": return hud_foreground(hud, value);

        case "glowColor": return hud_glowColor(hud, value);
        case "glowAlpha": return hud_glowAlpha(hud, value);
        case "setPulseFX":
            return hud_setPulseFX(hud, value[0], value[1], value[2]);

        case "hidewhendead": return hud_hidewhendead(hud, value);
        case "hidewhenindemo": return hud_hidewhenindemo(hud, value);
        case "hidewheninkillcam": return hud_hidewheninkillcam(hud, value);
        case "hidewheninmenu": return hud_hidewheninmenu(hud, value);

        case "fadeOvertime": return hud_fadeOverTime(hud, value);
    }
    printlnf("^1Error:^7 Unknown property: %s", key);
    return hud;
}

/*
 * hud_client_element(entity) Creates a new client HUD element for the given entity
 *
 * Params:
 *    entity - The entity for which to create the HUD element
 *
 * Returns:
 *    A struct containing the HUD element and its properties
 *
 * Example Usage:
 * ```
 * hud = hud_client_element(entity);
 * ```
 */
hud_client_hud_element(entity) {
    ce = SpawnStruct();

    // ce.element holds the client hud element
    ce.element = NewClientHudElem(entity);

    // ce.properties holds the json data
    ce.properties = json_object();
    return ce;
}

hud_server_font_string(font, scale) {
    ce = SpawnStruct();
    
    // ce.element holds the server font string
    ce.element = CreateServerFontString(font, float(scale));

    // ce.properties holds the json data
    ce.properties = json_object();
    return ce;
}

/*
 * hud_x(hud, value) Sets the X position for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the X position
 *    value - The X position to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_x(self.hud, 100);
 * ```
 */
hud_x(hud, value) {
    hud.element.x = value;
    hud.properties = object_add(hud.properties, "x", value);
    return hud;
}

/*
 * hud_y(hud, value) Sets the Y position for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the Y position
 *    value - The Y position to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_y(self.hud, 100);
 * ```
 */
hud_y(hud, value) {
    hud.element.y = value;
    hud.properties = object_add(hud.properties, "y", value);
    return hud;
}

/*
 * hud_setText(hud, text) Sets the text for the given HUD element
 *
 * Params:
 *    hud  - The HUD element for which to set the text
 *    text - The text to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_setText(self.hud, "Hello, World!");
 * ```
 */
hud_setText(hud, text) {
    hud.element SetText(text);
    hud.properties = object_add(hud.properties, "setText", text);
    return hud;
}

/*  
 * hud_setPoint(hud, point) Sets the point for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the point
 *    point - The point to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_setPoint(self.hud, "CENTER", "CENTER", 0, 0);
 * ```
 */
hud_setPoint(hud, xPoint, yPoint, x, y) {
    hud.element SetPoint(xPoint, yPoint, x, y);
    hud.properties = object_add(hud.properties, "setPoint", _build_array(xPoint, yPoint, x, y));
    return hud;
}

/*
 * hud_setShader(hud, shader, x, y) Sets the shader for the given HUD element
 *
 * Params:
 *    hud    - The HUD element for which to set the shader
 *    shader - The shader to set
 *    x      - The X position for the shader
 *    y      - The Y position for the shader
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_setShader(self.hud, "shader", 0, 0);
 * ```
 */
hud_setShader(hud, shader, x, y) {
    hud.element SetShader(shader, x, y);
    hud.properties = object_add(hud.properties, "setShader", shader);
    return hud;
}

/*
 * hud_alignX(hud, alignX) Sets the X alignment for the given HUD element
 *
 * Params:
 *    hud    - The HUD element for which to set the X alignment
 *    alignX - The X alignment to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_alignX(self.hud, "left");
 * ```
 */
hud_alignX(hud, alignX) {
    hud.element.alignX = alignX;
    hud.properties = object_add(hud.properties, "alignX", alignX);
    return hud;
}

/*
 * hud_alignY(hud, alignY) Sets the Y alignment for the given HUD element
 *
 * Params:
 *    hud    - The HUD element for which to set the Y alignment
 *    alignY - The Y alignment to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_alignY(self.hud, "top");
 * ```
 */
hud_alignY(hud, alignY) {
    hud.element.alignY = alignY;
    hud.properties = object_add(hud.properties, "alignY", alignY);
    return hud;
}

/*
 * hud_horzalign(hud, value) Sets the horizontal alignment for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the horizontal alignment
 *    value - The horizontal alignment to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_horzalign(self.hud, "left");
 * ```
 */
hud_horzalign(hud, value) {
    hud.element.horzalign = value;
    hud.properties = object_add(hud.properties, "horzalign", value);
    return hud;
}

/*
 * hud_vertalign(hud, value) Sets the vertical alignment for the given HUD element
 *
 * Params:
 *    hud  - The HUD element for which to set the vertical alignment
 *    value - The vertical alignment to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_vertalign(self.hud, "top");
 * ```
 */
hud_vertalign(hud, value) {
    hud.element.vertalign = value;
    hud.properties = object_add(hud.properties, "vertalign", value);
    return hud;
}

/*
 * hud_font(hud, font) Sets the font for the given HUD element
 *
 * Params:
 *    hud  - The HUD element for which to set the font
 *    font - The font to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_font(self.hud, "objective");
 * ```
 */
hud_font(hud, font) {
    hud.element.font = font;
    hud.properties = object_add(hud.properties, "font", font);
    return hud;
}

/*
 * hud_fontScale(hud, fontScale) Sets the font scale for the given HUD element
 *
 * Params:
 *    hud       - The HUD element for which to set the font scale
 *    fontScale - The font scale to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_fontScale(self.hud, 1.0);
 * ```
 */
hud_fontScale(hud, fontScale) {
    hud.element.fontScale = fontScale;
    hud.properties = object_add(hud.properties, "fontScale", fontScale);
    return hud;
}

/*
 * hud_color(hud, color) Sets the color for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the color
 *    color - The color to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_color(self.hud, (255, 255, 255));
 * ```
 */
hud_color(hud, color) {
    hud.element.color = color;
    hud.properties = object_add(hud.properties, "color", _build_array(color[0], color[1], color[2]));
    return hud;
}

/*
 * hud_alpha(hud, alpha) Sets the alpha for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the alpha
 *    alpha - The alpha to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_alpha(self.hud, 1.0);
 * ```
 */
hud_alpha(hud, alpha) {
    hud.element.alpha = alpha;
    hud.properties = object_add(hud.properties, "alpha", alpha);
    return hud;
}

/* 
 * hud_glowColor(hud, color) Sets the glow color for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the glow color
 *    color - The glow color to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_glowColor(self.hud, (255, 255, 255));
 * ```
 */
hud_glowColor(hud, color) {
    hud.element.glowColor = color;
    hud.properties = object_add(hud.properties, "glowColor", _build_array(color[0], color[1], color[2]));
    return hud;
}

/*
 * hud_glowAlpha(hud, alpha) Sets the glow alpha for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the glow alpha
 *    alpha - The glow alpha to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_glowAlpha(self.hud, 1.0);
 * ```
 */
hud_glowAlpha(hud, alpha) {
    hud.element.glowAlpha = alpha;
    hud.properties = object_add(hud.properties, "glowAlpha", alpha);
    return hud;
}

/*
 * hud_sort(hud, sort) Sets the sort order for the given HUD element
 *
 * Params:
 *    hud  - The HUD element for which to set the sort order
 *    sort - The sort order to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_sort(self.hud, 1);
 * ```
 */
hud_sort(hud, sort) {
    hud.element.sort = sort;
    hud.properties = object_add(hud.properties, "sort", sort);
    return hud;
}

/*
 * hud_foreground(hud, state) Sets the foreground state for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the foreground state
 *    state - The foreground state to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_foreground(self.hud, true);
 * ```
 */
hud_foreground(hud, state) {
    hud.element.foreground = state;
    hud.properties = object_add(hud.properties, "foreground", state);
    return hud;
}

/*
 * hud_hidewhendead(hud, state) Sets the hide when dead state for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the hide when dead state
 *    state - The hide when dead state to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_hidewhendead(self.hud, true);
 * ```
 */
hud_hidewhendead(hud, state) {
    hud.element.hidewhendead = state;
    hud.properties = object_add(hud.properties, "hidewhendead", state);
    return hud;
}

/*
 * hud_hidewhenindemo(hud, state) Sets the hide when in demo state for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the hide when in demo state
 *    state - The hide when in demo state to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_hidewhenindemo(self.hud, true);
 * ```
 */
hud_hidewhenindemo(hud, state) {
    hud.element.hidewhenindemo = state;
    hud.properties = object_add(hud.properties, "hidewhenindemo", state);
    return hud;
}

/*
 * hud_hidewheninkillcam(hud, state) Sets the hide when in killcam state for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the hide when in killcam state
 *    state - The hide when in killcam state to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_hidewheninkillcam(self.hud, true);
 * ```
 */
hud_hidewheninkillcam(hud, state) {
    hud.element.hidewheninkillcam = state;
    hud.properties = object_add(hud.properties, "hidewheninkillcam", state);
    return hud;
}

/*
 * hud_hidewheninmenu(hud, state) Sets the hide when in menu state for the given HUD element
 *
 * Params:
 *    hud   - The HUD element for which to set the hide when in menu state
 *    state - The hide when in menu state to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_hidewheninmenu(self.hud, true);
 * ```
 */
hud_hidewheninmenu(hud, state) {
    hud.element.hidewheninmenu = state;
    hud.properties = object_add(hud.properties, "hidewheninmenu", state);
    return hud;
}

/*
 * hud_moveOvertime(hud, overtime) Sets the move over time for the given HUD element
 *
 * Params:
 *    hud      - The HUD element for which to set the move over time
 *    overtime - The move over time to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_moveOvertime(self.hud, 1.0);
 * ```
 */
hud_moveOvertime(hud, overtime) {
    hud.element MoveOverTime(overtime);
    hud.properties = object_add(hud.properties, "moveOverTime", overtime);
    return hud;
}

/*
 * hud_fadeOverTime(hud, overtime) Sets the fade over time for the given HUD element
 *
 * Params:
 *    hud      - The HUD element for which to set the fade over time
 *    overtime - The fade over time to set
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_fadeOverTime(self.hud, 1.0);
 * ```
 */
hud_fadeOverTime(hud, overtime) {
    hud.element FadeOverTime(overtime);
    hud.properties = object_add(hud.properties, "fadeOverTime", overtime);
    return hud;
}

/*
 * hud_setPulseFx(hud, speed, decaystart, decayduration) Sets the pulse effect for the given HUD element
 *
 * Params:
 *    hud           - The HUD element for which to set the pulse effect
 *    speed         - The speed of the pulse effect
 *    decaystart    - The start of the decay for the pulse effect
 *    decayduration - The duration of the decay for the pulse effect
 *
 * Returns:
 *    The updated HUD element
 *
 * Example Usage:
 * ```
 * self.hud = hud_client_element(self);
 * self.hud = hud_setPulseFx(self.hud, 1.0, 0.5, 2.0);
 * ```
 */
hud_setPulseFX(hud, speed, decaystart, decayduration) {
    hud.element SetPulseFX(speed, decaystart, decayduration);
    hud.properties = object_add(hud.properties, "setPulseFX", _build_array(speed, decaystart, decayduration));
    return hud;
}

// _build_array(a, b, c, d) Helper function that builds an array from three or four values
_build_array(a, b , c, d) {
    arr = json_array();
    arr = array_add(arr, a);
    arr = array_add(arr, b);
    arr = array_add(arr, c);

    if (isdefined(d)) {
        arr = array_add(arr, d);
    }
    return arr;
}