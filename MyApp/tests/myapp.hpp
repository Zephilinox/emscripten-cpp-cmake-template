//SELF
#include "MyApp/Game.hpp"

//LIBS
#include <doctest/doctest.h>

//STD

TEST_CASE("test")
{
    CHECK_EQ(Game::add(1, 2), 3);
}