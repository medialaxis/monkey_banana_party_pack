#include <deque>
#include <filesystem>
#include <iostream>

using std::filesystem::path;
using std::filesystem::current_path;
using std::filesystem::directory_iterator;
using std::filesystem::filesystem_error;

int main(int argc, char *argv[])
{
    std::deque<path> work;
    work.push_back(current_path());

    while (!work.empty()) {
        path curr = work.front();
        work.pop_front();

        std::cout << curr.string() << std::endl;

        try {
            for (auto& dir : directory_iterator(curr)) {
                if (dir.is_symlink()) continue;
                if (!dir.is_directory()) continue;
                if (dir.path().filename() == ".git") continue;
                if (dir.path().filename() == ".mypy_cache") continue;
                if (dir.path().filename() == ".cache") continue;
                if (dir.path().filename() == "__pycache__") continue;
                if (dir.path().filename() == ".stack-work") continue;

                work.push_back(dir.path());
            }
        }
        catch (const filesystem_error& e) {
            if (e.code() != std::errc::permission_denied) throw;
        }
    }

    return 0;
}
