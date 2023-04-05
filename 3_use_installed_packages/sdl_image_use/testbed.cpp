#define SDL_MAIN_HANDLED // ! to resolve the `invoke_main()` link error. put it before include sdl.h
#include <SDL.h>
#include <SDL_render.h>
#include <SDL_image.h>
#include <stdio.h>

#define MY_SDL_LOGE printf("Error in %s:%d, reason: %s\n", __FILE__, __LINE__, SDL_GetError());

// https://wiki.libsdl.org/SDL_CreateRenderer
int main()
{
    if (SDL_Init(SDL_INIT_VIDEO) != 0)
    {
        MY_SDL_LOGE;
        return 1;
    }
    const char* title = "Hello SDL2";
    int x = 300;
    int y = 200;
    int w = 640;
    int h = 480;
    SDL_Window* window = SDL_CreateWindow(title, x, y, w, h, SDL_WINDOW_OPENGL);
    if (window == NULL)
    {
        MY_SDL_LOGE;
        return 2;
    }

    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (renderer == NULL)
    {
        MY_SDL_LOGE;
        return 3;
    }

    const char* image_path = "frontground.png";
    // load texture, the SDL method, only support BMP image
    //SDL_Surface* surface = SDL_LoadBMP(image_path);
    //SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer, surface);

    // load texture, the SDL2_image method, support many image formats
    SDL_Texture* texture = IMG_LoadTexture(renderer, image_path);

    bool quit = false;
    SDL_Event evt;
    while (!quit)
    {
        while (SDL_PollEvent(&evt))
        {
            if (evt.type == SDL_QUIT)
            {
                quit = true;
            }
        }

        // 清除背景
        SDL_RenderClear(renderer);
        // 渲染图像
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        // 显示图像
        SDL_RenderPresent(renderer);
    }

    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);

    SDL_Quit();

    return 0;
}