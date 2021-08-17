//SELF
#include "MyLib/Library.hpp"

//LIBS
#include <doctest/doctest.h>

//STD

TEST_CASE("test")
{
    Library lib;
    CHECK(lib.doThing());
}