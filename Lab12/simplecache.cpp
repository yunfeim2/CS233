#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details

    for(int i = 0; i < _associativity; i ++){
      	if((!_cache[index][i].valid()) || _cache[index][i].tag() != tag){
	  		continue;
	  	}
	  	return _cache[index][i].get_byte(block_offset);
    }
    return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
	for(int i = 0; i < _associativity; i ++){
      	if(!_cache[index][i].valid()){
	  		_cache[index][i].replace(tag, data);
	  		return;
	  	}
    }
    _cache[index][0].replace(tag, data);
}

