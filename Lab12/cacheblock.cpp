#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO

	size_t off = _cache_config.get_num_block_offset_bits();
	size_t idx = _cache_config.get_num_index_bits();
	if(off + idx == 0){
		return _tag;
	}
	uint32_t address = (_tag << (off + idx)) + (_index << (off));
    return address;
}
