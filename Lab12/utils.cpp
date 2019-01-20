#include "utils.h"
#include <iostream>
using namespace std;

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	size_t idx = cache_config.get_num_index_bits();
	size_t off = cache_config.get_num_block_offset_bits();
	if(idx + off == 32){
		return 0;
	}
	address = address >> (idx + off);
	return address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	size_t tag = cache_config.get_num_tag_bits();
	size_t off = cache_config.get_num_block_offset_bits();
	if(tag + off == 32){
		return 0;
	}
	address = address << tag;
	address = address >> (tag + off);
	return address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	size_t tag = cache_config.get_num_tag_bits();
	size_t idx = cache_config.get_num_index_bits();
	if(tag + idx == 32){
		return 0;
	}
	address = address << (tag + idx);
	address = address >> (tag + idx);
  	return address;
}
