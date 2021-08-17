#include "Library.hpp"

//SELF

//LIBS
#ifdef __EMSCRIPTEN__
    #include <emscripten.h>
    #include <cstring> //memcpy for SDL
    #include <SDL.h>

    #define GL_GLEXT_PROTOTYPES 1
    #include <SDL_opengles2.h>
#else
    #include <cstring> //memcpy for SDL
    #include <SDL.h>

    #include <glad/glad.h>
#endif

//STD

void Library::clearColour()
{
    glClearColor(1.0f, 0.7f, 0.1f, 1.0f);
}

bool Library::doThing()
{
    return true;
}