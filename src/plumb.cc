#include <iostream>
#include <regex>
#include <fmt/core.h>
#include <fmt/ostream.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc != 2) return 1;

    std::string selection(argv[1]);
    std::smatch match;

    std::regex url_re("(http://|https://)[a-zA-Z0-9-_~=?&/\\.]*");
    std::regex file_re("[a-zA-Z0-9-_~=?&/\\.]*");

    if (std::regex_search(selection, match, url_re)) {
        fmt::print("'{}'\n", match.str());
        system(fmt::format("openbg '{}'", match.str()).c_str());
        return 0;
    }

    if (std::regex_search(selection, match, file_re)) {
        fmt::print("'{}'\n", match.str());
        system(fmt::format("openbg '{}'", match.str()).c_str());
        return 0;
    }

    return 1;
}
