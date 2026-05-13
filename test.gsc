#include scripts\hud;

init() {
    level thread onPlayerConnect();
}

onPlayerConnect() {
    level endon("game_ended");
    for(;;) {
        level waittill("connected", player);
        player.ss = load_server_string("hud.json");
    }
}