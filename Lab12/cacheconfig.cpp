#include "cacheconfig.h"
#include "utils.h"
using namespace std;

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 
	size_t block = size / block_size;
	size_t index_num = block / associativity;
	_num_block_offset_bits = log_2(block_size);
  	_num_index_bits = log_2(index_num);
  	_num_tag_bits = 32 - _num_index_bits - _num_block_offset_bits;

}
