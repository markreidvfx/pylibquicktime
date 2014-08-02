
from libc.stdint cimport uint32_t
cimport lib


cdef class Quicktime(object):
    
    cdef lib.quicktime_t *ptr
    
    def __cinit__(self):
        self.ptr = NULL
    
    def __init__(self, bytes path):
        

        self.ptr = lib.quicktime_open(path, 1, 0)
        
    def dump(self):
        lib.quicktime_dump(self.ptr)
        
    def video_tracks(self):
        return lib.quicktime_video_tracks(self.ptr)
    
    def tape_names(self):
        cdef char* name
        
        name = lib.lqt_get_timecode_tape_name(self.ptr, 0)
        if name:
            return name
    
    def timecode(self):
        cdef uint32_t timecode = 0
        cdef int result
        
        result = lib.lqt_read_timecode(self.ptr, 0, &timecode)
        if result:
            return timecode