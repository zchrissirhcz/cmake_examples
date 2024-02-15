#include "imgui.h"
#include "imgui-SFML.h"

#include <SFML/Graphics/CircleShape.hpp>
#include <SFML/Graphics/RenderWindow.hpp>
#include <SFML/System/Clock.hpp>
#include <SFML/Window/Event.hpp>

int main()
{
    sf::RenderWindow window(sf::VideoMode(640, 480), "ImGui + SFML = <3");
    window.setFramerateLimit(60);
    ImGui::SFML::Init(window); // [imgui-SFML]

    sf::CircleShape shape(100.f);
    shape.setFillColor(sf::Color::Green);

     sf::Clock deltaClock;
    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            ImGui::SFML::ProcessEvent(window, event); // [imgui-SFML]

            if (event.type == sf::Event::Closed)
            {
                window.close();
            }
        }

        ImGui::SFML::Update(window, deltaClock.restart()); // [imgui-SFML]

        ImGui::ShowDemoWindow(); // [imgui]

        ImGui::Begin("Hello, world!"); // [imgui]
        ImGui::Button("Look at this pretty button"); // [imgui]
        ImGui::End(); // [imgui]

        window.clear();
        window.draw(shape);
        ImGui::SFML::Render(window); // [imgui-SFML]
        window.display();
    }

    ImGui::SFML::Shutdown(); // [imgui-SFML]

    return 0;
}
