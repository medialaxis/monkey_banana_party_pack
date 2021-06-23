#include <deque>
#include <filesystem>
#include <iostream>
#include <vector>
#include <glob.h>

using std::filesystem::recursive_directory_iterator;
using std::filesystem::directory_options;

int main(int argc, char *argv[])
{
    for (auto& ent : recursive_directory_iterator("/mnt/extra", directory_options::skip_permission_denied)) {
        std::cout << ent.path().string() << std::endl;
    }

    for (auto& ent : recursive_directory_iterator("/etc", directory_options::skip_permission_denied)) {
        std::cout << ent.path().string() << std::endl;
    }

    return 0;
}
