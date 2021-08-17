// https://gist.github.com/SuperV1234/5c5ad838fe5fe1bf54f9

//SELF
#include "MyApp/Game.hpp"

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
    #undef main

    #include <glad/glad.h>
#endif

#include <MyLib/Library.hpp>
#include <imgui.h>
#include <backends/imgui_impl_sdl.h>
#include <backends/imgui_impl_opengl3.h>

//STD
#include <exception>
#include <functional>
#include <iostream>
#include <array>

// Shader sources
const GLchar* vertexSource = "attribute vec4 position;    \n"
                             "void main()                  \n"
                             "{                            \n"
                             "   gl_Position = vec4(position.xyz, 1.0);  \n"
                             "}                            \n";
const GLchar* fragmentSource = "precision mediump float;\n"
                               "void main()                                  \n"
                               "{                                            \n"
                               "  gl_FragColor = vec4 (1.0, 1.0, 1.0, 1.0 );\n"
                               "}                                            \n";

std::function<bool()> loop;

void main_loop()
{
#ifndef __EMSCRIPTEN__
    while (loop())
    {
    }
#else
    loop();
#endif
}

int main(int, char*[])
{
    SDL_Init(SDL_INIT_VIDEO);

    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

    auto* wnd = SDL_CreateWindow(
        "MyApp",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        1280,
        720,
        SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);

    auto* glc = SDL_GL_CreateContext(wnd);
    SDL_GL_SetSwapInterval(0); // VSync off, though when running in a browser it may get overriden

#ifndef __EMSCRIPTEN__
    if (!static_cast<bool>(gladLoadGLES2Loader(static_cast<GLADloadproc>(SDL_GL_GetProcAddress))))
    {
        std::cout << "Failed to initialize OpenGLES loader!\n";
        return 1;
    }

    std::cout << "OpenGLES version loaded: " << GLVersion.major << "."
              << GLVersion.minor << std::endl;
#endif

    [[maybe_unused]] auto* rdr = SDL_CreateRenderer(wnd, -1, SDL_RENDERER_ACCELERATED);

    // Create Vertex Array Object
    GLuint vao = 0;
    glGenVertexArraysOES(1, &vao);
    glBindVertexArrayOES(vao);

    // Create a Vertex Buffer Object and copy the vertex data to it
    GLuint vbo = 0;
    glGenBuffers(1, &vbo);

    std::array<GLfloat, 6> vertices{ 0.0f, 0.5f, 0.5f, -0.5f, -0.5f, -0.5f };

    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(GLfloat), vertices.data(), GL_STATIC_DRAW);

    // Create and compile the vertex shader
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexSource, nullptr);
    glCompileShader(vertexShader);

    // Create and compile the fragment shader
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentSource, nullptr);
    glCompileShader(fragmentShader);

    // Link the vertex and fragment shader into a shader program
    GLuint shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    // glBindFragDataLocation(shaderProgram, 0, "outColor");
    glLinkProgram(shaderProgram);
    glUseProgram(shaderProgram);

    // Specify the layout of the vertex data
    GLint posAttrib = glGetAttribLocation(shaderProgram, "position");
    glEnableVertexAttribArray(static_cast<GLuint>(posAttrib));
    glVertexAttribPointer(static_cast<GLuint>(posAttrib), 2, GL_FLOAT, GL_FALSE, 0, nullptr);

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();
    (void)io;
    //io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;  // Enable Keyboard Controls

    ImGui_ImplSDL2_InitForOpenGL(wnd, glc);
    ImGui_ImplOpenGL3_Init("#version 100"); // WebGL1 with OpenGLES2
    //ImGui_ImplOpenGL3_Init("#version 300 es"); // WebGL2 with OpenGLES2

    // Setup style
    ImGui::StyleColorsClassic();

    bool show_demo_window = true;

    loop = [&] {
        // Events
        SDL_Event e;
        while (SDL_PollEvent(&e) != 0)
        {
            if (e.type == SDL_QUIT)
                return false;

            ImGui_ImplSDL2_ProcessEvent(&e);
        }

        // Updates
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplSDL2_NewFrame(wnd);
        ImGui::NewFrame();

        if (show_demo_window)
            ImGui::ShowDemoWindow(&show_demo_window);

        ImGui::Begin("FPS");
        ImGui::Text("Application average %.3f ms/frame (%.1f FPS)", 1000.0 / static_cast<double>(ImGui::GetIO().Framerate), static_cast<double>(ImGui::GetIO().Framerate));
        ImGui::End();

        ImGui::Render();

        // Rendering
        SDL_GL_MakeCurrent(wnd, glc);

        // Clear the screen
        Library::clearColour();
        glClear(GL_COLOR_BUFFER_BIT);

        // Adjust the viewport in case it is resized
        glViewport(0, 0, static_cast<int>(io.DisplaySize.x), static_cast<int>(io.DisplaySize.y));

        // Draw a triangle from the 3 vertices, underneath IMGUI
        glDrawArrays(GL_TRIANGLES, 0, 3);

        // Draw IMGUI
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

        SDL_GL_SwapWindow(wnd);

        return true;
    };

#ifndef __EMSCRIPTEN__
    main_loop();
#else
    emscripten_set_main_loop(main_loop, 0, true);
#endif

    // Cleanup
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplSDL2_Shutdown();
    ImGui::DestroyContext();

#ifndef __EMSCRIPTEN__
    SDL_GL_DeleteContext(glc);
    SDL_DestroyWindow(wnd);
    SDL_Quit();
#endif

    return 0;
}