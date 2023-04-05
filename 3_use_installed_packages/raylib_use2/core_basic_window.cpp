#include "raylib.h"

int main()
{
    const int screen_width = 800;
    const int screen_height = 450;

    InitWindow(screen_width, screen_height, "raylib [core] example - basic window");
    SetTargetFPS(60);
    while (!WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update (TODO: update variables here)

        // Draw
        BeginDrawing();
        {
            ClearBackground(RAYWHITE);
            const int pos_x = 190;
            const int pos_y = 200;
            const int font_size = 20;
            DrawText("Congrats! You created your first window!", pos_x, pos_y, font_size, LIGHTGRAY);
        }
        EndDrawing();
    }

    CloseWindow();

    return 0;
}