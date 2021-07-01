#include <deque>
#include <filesystem>
#include <iostream>
#include <vector>
#include <glob.h>

using std::filesystem::recursive_directory_iterator;
using std::filesystem::directory_options;
using std::filesystem::filesystem_error;

int main(int argc, char *argv[])
{
    try {
        for (auto& ent : recursive_directory_iterator("/mnt/extra", directory_options::skip_permission_denied)) {
            std::cout << ent.path().string() << std::endl;
        }
    }
    catch (const filesystem_error& e) {
        if (e.code() != std::errc::no_such_file_or_directory) {
            throw;
        }
    }

    for (auto& ent : recursive_directory_iterator("/etc", directory_options::skip_permission_denied)) {
        std::cout << ent.path().string() << std::endl;
    }

    return 0;
}
