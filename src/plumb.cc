#include <iostream>
#include <regex>
#include <fmt/core.h>
#include <fmt/ostream.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc != 2) return 1;

    std::string s(argv[1]);
    std::regex regex("(http://|https://)[a-zA-Z0-9-~=?&/\\.]*");
    std::smatch match;

    while (std::regex_search(s, match, regex)) {
        fmt::print("'{}'\n", match.str());
        system(fmt::format("firefox '{}'", match.str()).c_str());
        s = match.suffix().str();
    }

    return 0;
}
