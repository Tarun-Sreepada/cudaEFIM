#pragma once

#include "../main.cuh"

void print_help(const char* program_name);
params parse_arguments(int argc, char* argv[]);
void print_arguments(const params& p);

// Function declarations

// // Function to determine the separator character
// char get_separator(const std::string &separator);

// // Function to read the file and calculate TWU
// file_data read_file(const params &p, std::unordered_map<std::string, uint32_t> &twu, char separator_char);

// std::tuple<
//     std::unordered_map<std::vector<uint32_t>, std::vector<uint32_t>, VectorHash>,
//     std::vector<uint32_t>,
//     std::vector<uint32_t>,
//     std::unordered_map<uint32_t, std::string>>
//                     parse_file(
//                         const params &p);