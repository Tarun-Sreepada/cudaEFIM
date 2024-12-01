#pragma once
#include <vector>

struct vector_hash
{
    std::size_t operator()(std::vector<uint32_t> const &vec) const
    {
        std::size_t seed = vec.size();
        for (auto x : vec)
        {
            x = ((x >> 16) ^ x) * 0x45d9f3b;
            x = ((x >> 16) ^ x) * 0x45d9f3b;
            x = (x >> 16) ^ x;
            seed ^= x + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        }
        return seed;
    }
};
