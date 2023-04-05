// https://lanyundev.xyz/posts/a5945d21.html#%E9%85%8D%E7%BD%AE
#include <ncurses.h>
#include <stdlib.h>
#include <string.h>

int main(void){
    initscr();
    raw();
    noecho();
    curs_set(0);
  
    const char* c = "My First Window";

    mvprintw(LINES/2,(COLS-strlen(c))/2,c);
    printw("\nHello World!");
    refresh();
  
   	getch();
    endwin();
  
    return EXIT_SUCCESS;
}
