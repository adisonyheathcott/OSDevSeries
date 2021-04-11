#include <array>
#include <string>
#include <iostream>
#include <fstream>
#include <filesystem>

std::array<std::string, 2> writeOrder = { "bootloader.asm", "secondboot.asm" };

int main(int argc, char* argv[]) {
    if (argc <= 1) {
        std::cout << "You need to specify a folder.\n";
        return -1;
    }

    // Create or open the img file
    std::ofstream imgFile("os.img", std::ios::binary | std::ios::out);

    // Get directory info
    std::string path = "./";
    path.append(argv[1]);

    // Check that all the files exist that we need
    bool found = false;
    for (int i = 0; i < writeOrder.size(); i++) {
        for (const auto& entry : std::filesystem::directory_iterator(path)) {
            if (entry.path().string().substr(entry.path().string().find_last_of('/') + 1) == writeOrder[i]) {
                found = true;
                
                // Compile the file
                int subIndex = entry.path().string().find_last_of('/') + 1;
                system(std::string(std::string("cd ").append(argv[1]) + " && nasm " + entry.path().string().substr(subIndex) + " -f bin -o " + entry.path().string().substr(subIndex, entry.path().string().length() - subIndex - 4)).c_str());

                // Write the compiled program to the img file
                std::ifstream rf(entry.path().string().substr(0, entry.path().string().find_last_of('.')), std::ios::binary | std::ios::in);
                if (!rf) { std::cout << "Failed to open the file.\n"; return -1; }
                std::copy(std::istreambuf_iterator<char>(rf), std::istreambuf_iterator<char>( ), std::ostreambuf_iterator<char>(imgFile));

                rf.close();

                break;
            }
        }

        if (found) continue;

        std::cout << "One of the required files was not found.\n";
        return -1;
    }

    // Close the file
    imgFile.close();

    return 0;
}