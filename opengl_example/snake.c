#include <assert.h>
#include <stdlib.h>
#include <time.h>

#ifdef __APPLE__
#include <GLUT/glut.h>    // Header File For The GLUT Library 
#include <OpenGL/gl.h>	// Header File For The OpenGL32 Library
#include <OpenGL/glu.h>	// Header File For The GLu32 Library
#else
#include <GL/glut.h>    // Header File For The GLUT Library 
#include <GL/gl.h>	// Header File For The OpenGL32 Library
#include <GL/glu.h>	// Header File For The GLu32 Library
#endif

#include <unistd.h>     // Header file for sleeping.
/* ascii code for the escape key */
#define ESCAPE 27

/* 大小定义 */
#define ISNAKE_WIDTH  15
#define ISNAKE_HEIGHT 15

/* 方向定义 */
#define DIR_UP         0
#define DIR_DOWN       1
#define DIR_LEFT       2
#define DIR_RIGHT      3

/* 颜色定义（RGB） */
#define  CLR_BLACK      0.0f, 0.0f, 0.0f
#define  CLR_RED        1.0f, 0.0f, 0.0f
#define  CLR_GREEN      0.0f, 1.0f, 0.0f
#define  CLR_YELLOW     1.0f, 1.0f, 0.0f
#define  CLR_BLUE       0.0f, 0.0f, 1.0f
#define  CLR_MEGENTA    1.0f, 0.0f, 1.0f
#define  CLR_CYAN       0.0f, 1.0f, 1.0f
#define  CLR_WHITE      1.0f, 1.0f, 1.0f

/* 时间加快所要吃到的食物个数 */
#define  MIN_FOOD       20   
/* 最慢时间,ms */
#define  TIME_BASE      300
/* 最块时间,ms */
#define  TIME_MIN       50
/* 每次升级时间缩短单位,ms */
#define  TIME_UPUNIT    50


typedef struct _RGB{
    float r;
    float g;
    float b;
} RGB;

typedef struct Position{
    int x;
    int y;
}Pos;

typedef struct _SnakeNode{
    int    color;
    int    index_x;
    int    index_y;
    struct _SnakeNode *prev;
    struct _SnakeNode *next;
}SnakeNode;


struct _Snake{
    SnakeNode *head;
    SnakeNode *tail;
    int num;
} _snake;

RGB  _color[] = {
    { CLR_RED }, { CLR_GREEN } ,  { CLR_BLUE }, { CLR_YELLOW},
    { CLR_CYAN}, { CLR_MEGENTA},  { CLR_WHITE}, { CLR_BLACK},	 
};

/* 0, 1, 2, 3分别代表上下左右 */
int _direction = DIR_RIGHT;  /* 要控制的方向 */ 
int _move_dir = DIR_RIGHT;   /* 当前移动方向 */
int _dir_x[4] = {-1, 1, 0, 0};
int _dir_y[4] = { 0, 0,-1, 1};

/* 定时时间 */
int _timer = TIME_BASE;
/* 游戏结束标志 */
int _finish_flag = 0;
/* 暂停标志 */
int _pause_flag = 0;
/* 食物坐标 */
Pos _food_pos;
int _food_clr_id;

/* The number of our GLUT window */
int window; 
int wnd_width;
int wnd_height;

/* 移动，将最后一个节点变为头节点，根据方向改变坐标 */
void SnakeMove(int direction)
{
    /* 当前头部位置 */
    int x = _snake.head->index_x;
    int y = _snake.head->index_y;
    int c = _snake.head->color;
    SnakeNode *node = _snake.head;
    /* 移动之前改变颜色 */
    for ( ; node->next != NULL; node = node->next){
        node->color = node->next->color;
    }
    node->color = c;
    /* 将尾巴加到头部 */
    _snake.tail->prev->next = NULL;
    _snake.head->prev = _snake.tail;
    _snake.tail->next = _snake.head;
    _snake.head = _snake.tail;
    _snake.tail = _snake.tail->prev;
    _snake.head->prev = NULL;
    _snake.tail->next = NULL;
    /* 方向 */
    _snake.head->index_x = x + _dir_x[direction];
    _snake.head->index_y = y + _dir_y[direction];

    if (_snake.head->index_x < 0)                { _snake.head->index_x = ISNAKE_HEIGHT-1; }
    if (_snake.head->index_x > ISNAKE_HEIGHT-1)  { _snake.head->index_x = 0;               }
    if (_snake.head->index_y < 0)                { _snake.head->index_y = ISNAKE_WIDTH-1;  }
    if (_snake.head->index_y > ISNAKE_WIDTH-1 )  { _snake.head->index_y = 0;               }
    
    _move_dir = _direction;
}

/*
* 判断游戏是否结束
*/
int IsFinish(void)
{
    int x, y;
    SnakeNode *node;
    x = _snake.head->index_x + _dir_x[_direction];
    y = _snake.head->index_y + _dir_y[_direction];
    for (node = _snake.head->next; node != NULL; node = node->next){
        if (node->index_x == x && node->index_y == y){
            glutSetWindowTitle("  FINISHED !!");
            return 1;
        }
    }
    
    return 0;
}

/*
* 判断是否有食物
* 有返回1， 无则返回0
*/
int HasFood(void)
{
    SnakeNode *node = _snake.head;
    if (node->index_x + _dir_x[_direction] == _food_pos.x 
    && node->index_y + _dir_y[_direction] == _food_pos.y 
    ){
        return 1;
    }
    while( node != NULL ){
        if (node->index_x == _food_pos.x &&
            node->index_y == _food_pos.y){
            return 1;
        }
        node = node->next;
    }
    return 0;
}

void SnakeEat(int x, int y)
{
    SnakeNode *node = (SnakeNode*)malloc(sizeof(SnakeNode));
    node->index_x = x;
    node->index_y = y;
    _snake.head->prev = node;
    node->next = _snake.head;
    node->prev = NULL;
    _snake.head = node;
    _snake.num++;
    _snake.head->color = _food_clr_id;
}

int CorrectFood(int x, int y)
{
    SnakeNode *node = _snake.head;
    for ( ; node != NULL; node = node->next){
        if (node->index_x == x && node->index_y == y){
            return 0;
        }
    }
    return 1;
}

void RandomFood(void)
{
    int x, y;
    srand(time(NULL));
    do{
        x = (double)rand() / RAND_MAX * ISNAKE_HEIGHT-1;
        y = (double)rand() / RAND_MAX * ISNAKE_WIDTH-1;
    }while(!CorrectFood(x,y));
    _food_clr_id = (double)rand() / RAND_MAX * (sizeof(_color)/sizeof(_color[0])-2);	
    _food_pos.x = x; _food_pos.y = y;
}

/*
* 初始化一个带有n个方块的蛇
*/
void SnakeInit(int n)
{
    int i;
    SnakeNode *node;
    _snake.head = _snake.tail = (SnakeNode*)malloc(sizeof(SnakeNode));
    _snake.head->index_x = ISNAKE_HEIGHT/2;
    _snake.head->index_y = ISNAKE_WIDTH/2;
    _snake.head->color = 0;
    for (i = 0; i < n-1; ++i){
        node = (SnakeNode*)malloc(sizeof(SnakeNode));
        node->index_x = _snake.tail->index_x;
        node->index_y = _snake.tail->index_y-1;
        node->color = (i+1)%7;
        node->prev = _snake.tail;
        _snake.tail->next = node;
        _snake.tail = node; 
    }
    _snake.head->prev = NULL;
    _snake.tail->next = NULL;
    _snake.num = n;	
    RandomFood();
    _direction = DIR_RIGHT;
}

/*
* OpenGL初始化函数
*/
void InitGL(int Width, int Height)         // We call this right after our OpenGL window is created.
{
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);   // This Will Clear The Background Color To Black
    glClearDepth(1.0);                      // Enables Clearing Of The Depth Buffer
    glDepthFunc(GL_LESS);                   // The Type Of Depth Test To Do
    glEnable(GL_DEPTH_TEST);                // Enables Depth Testing
    glShadeModel(GL_SMOOTH);                // Enables Smooth Color Shading

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();                       // Reset The Projection Matrix

    gluOrtho2D(0.0f,(GLdouble)Width, 0.0f, (GLdouble)Height);
}

/* The function called when our window is resized */
void ReSizeGLScene(int Width, int Height)
{
if (Height==0)              // Prevent A Divide By Zero If The Window Is Too Small
    Height=1;

glViewport(0, 0, Width, Height);    // Reset The Current Viewport And Perspective Transformation

glMatrixMode(GL_PROJECTION);
glLoadIdentity();

gluOrtho2D(0.0f, (GLdouble)Width, 0.0f, (GLdouble)Height);
}

/* The main drawing function. */
void DrawGLScene()
{
    int i, j, clr;
    static double unit_x = 2.0f/ISNAKE_WIDTH;
    static double unit_y = 2.0f/ISNAKE_HEIGHT;
    SnakeNode *node = _snake.head;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Clear The Screen And The Depth Buffer
    glLoadIdentity();       // Reset The View  （将当前点移到屏幕中心）

    glTranslatef(-1.0f, 1.0f, 0.0f);
    glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
    glBegin(GL_QUADS);
    glColor3f(CLR_WHITE);
    for (i = 0; i < ISNAKE_HEIGHT; ++i){
        for (j = 0; j < ISNAKE_WIDTH; ++j){
            glVertex3f((j  ) * unit_x, -(i  ) * unit_y, 0.0f);
            glVertex3f((j+1) * unit_x, -(i  ) * unit_y, 0.0f);
            glVertex3f((j+1) * unit_x, -(i+1) * unit_y, 0.0f);
            glVertex3f((j  ) * unit_x, -(i+1) * unit_y, 0.0f);
        }
    }
    glEnd();

    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
    glBegin(GL_QUADS);
    /* snake */
    while(node != NULL){
        clr = node->color;
        glColor3f(_color[clr].r, _color[clr].g, _color[clr].b);
        glVertex3f((node->index_y  ) * unit_x, -(node->index_x  ) * unit_y, 0.0f);
        glVertex3f((node->index_y+1) * unit_x, -(node->index_x  ) * unit_y, 0.0f);
        glVertex3f((node->index_y+1) * unit_x, -(node->index_x+1) * unit_y, 0.0f);
        glVertex3f((node->index_y  ) * unit_x, -(node->index_x+1) * unit_y, 0.0f);

        node = node->next;
    }
    /* food */
    glColor3f(_color[_food_clr_id].r, _color[_food_clr_id].g, _color[_food_clr_id].b);
    glVertex3f((_food_pos.y  ) * unit_x, -(_food_pos.x  ) * unit_y, 0.0f);
    glVertex3f((_food_pos.y+1) * unit_x, -(_food_pos.x  ) * unit_y, 0.0f);
    glVertex3f((_food_pos.y+1) * unit_x, -(_food_pos.x+1) * unit_y, 0.0f);
    glVertex3f((_food_pos.y  ) * unit_x, -(_food_pos.x+1) * unit_y, 0.0f);
    glEnd();

    glutSwapBuffers();
}

/*
* 定时器响应函数
*/
void OnTimer(int value)
{
    if (!value && !_pause_flag){
        if ( HasFood() ){
            SnakeEat(_food_pos.x, _food_pos.y); 
            RandomFood();
        }
        if (!IsFinish()){
            SnakeMove(_direction);
        }else{
            _finish_flag = 1;
        }
        _timer = (TIME_BASE - TIME_UPUNIT*_snake.num/MIN_FOOD);
        _timer = _timer > TIME_MIN ? _timer:TIME_MIN;
        glutTimerFunc(_timer,OnTimer,_finish_flag);
    }
}


/* The function called whenever a key is pressed. */
void keyPressed(unsigned char key, int x, int y) 
{
    /* avoid thrashing this procedure */
    usleep(100);

    if (key == ESCAPE) { 
        glutDestroyWindow(window); 
        exit(0);                   
    }

    switch(key){
    case ' ':                             /* pause */  
        _pause_flag = !_pause_flag;
        if (!_pause_flag){ 
            glutTimerFunc(_timer,OnTimer, _finish_flag); 
        }
        break;
    default:
        break;
    }
}

/*
* 方向键
*/
void OnDirection(int key, int x, int y)
{
    if (_pause_flag) { return; }
    
    switch(key){
    case GLUT_KEY_UP:   if (_move_dir != DIR_DOWN) { _direction = DIR_UP;  }
        break;
    case GLUT_KEY_DOWN: if (_move_dir != DIR_UP  ) { _direction = DIR_DOWN;}
        break;
    case GLUT_KEY_LEFT: if (_move_dir != DIR_RIGHT){ _direction = DIR_LEFT;}
        break;
    case GLUT_KEY_RIGHT:if (_move_dir != DIR_LEFT ){ _direction = DIR_RIGHT;}
        break;
    default:
        break;
    }
}


int main(int argc, char **argv) 
{
    SnakeInit(4);
    glutInit(&argc, argv);  
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH);  
    glutInitWindowSize(500, 500);  
    glutInitWindowPosition(0, 0);  
    window = glutCreateWindow("iSnake - sduzh 2013-12-23");  
    glutDisplayFunc(&DrawGLScene);  
    glutIdleFunc(&DrawGLScene); 
    glutReshapeFunc(&ReSizeGLScene);
    glutKeyboardFunc(&keyPressed);
    glutSpecialFunc(OnDirection);
    glutTimerFunc(_timer, OnTimer, _finish_flag);
    InitGL(500, 500);
    glutMainLoop();

    return 0;
}

// ————————————————
// 版权声明：本文为CSDN博主「sduzh9011」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
// 原文链接：https://blog.csdn.net/copica/article/details/17503011