
from libc.stdint cimport uint32_t
cimport lib

cdef class Track(object):

    def __cinit__(self, Quicktime qt = None, int index = 0):
        self.qt = qt
        self.index = 0
        
    def __init__(self):
        raise TypeError("%s cannot be instantiated from Python" %  self.__class__.__name__)

cdef class InputVideoTrack(Track):
    
    property width:
        def __get__(self):
            return lib.quicktime_video_width(self.qt.ptr, self.index)
    property height:
        def __get__(self):
            return lib.quicktime_video_height(self.qt.ptr, self.index)
    
    property time_scale:
        def __get__(self):
            return lib.lqt_video_time_scale(self.qt.ptr, self.index)
    
    property frame_rate:
        def __get__(self):
            return lib.quicktime_frame_rate(self.qt.ptr, self.index)
    property length:
        def __get__(self):
            return lib.quicktime_video_length(self.qt.ptr, self.index)
        
    property duration:
        def __get__(self):
            return lib.lqt_video_duration(self.qt.ptr, self.index)
    
    property depth:
        def __get__(self):
            return lib.quicktime_video_depth(self.qt.ptr, self.index)

cdef class InputAudioTrack(Track):
    pass

cdef class InputTextTrack(Track):
    pass

cdef class TrackList(object):
    
    def __cinit__(self, Quicktime qt = None):
        self.qt = qt
    
    def __init__(self):
        raise TypeError("%s cannot be instantiated from Python" %  self.__class__.__name__)
    
    def __getitem__(self, int index):
        
        if index < 0:
            index = len(self) + index
        
        if index >= len(self):
            raise IndexError()

        return self._get_track(index)
    
    def __len__(self):
        return self._get_len()

    cdef _get_track(self, int index):
        raise NotImplementedError()
    
    cdef int _get_len(self):
        raise NotImplementedError()
        
    
cdef class InputVideoTrackList(TrackList):
    
    cdef _get_track(self, int index):
        return InputVideoTrack.__new__(InputVideoTrack, self.qt, index)
        
    cdef int _get_len(self):
        return lib.quicktime_video_tracks(self.qt.ptr)

cdef class InputAudioTrackList(TrackList):
    pass

cdef class InputTextTrackList(TrackList):
    pass



cdef class Quicktime(object):

    def __cinit__(self):
        self.ptr = NULL
        
cdef class QuicktimeReader(Quicktime):
    def __init__(self, bytes path):
        self.ptr = lib.quicktime_open(path, 1, 0)

    property video_tracks:
        def __get__(self):
            return InputVideoTrackList.__new__(InputVideoTrackList, self)
        
    property audio_tracks:
        def __get__(self):
            return InputAudioTrackList.__new__(InputAudioTrackList, self)
    
    property text_tracks:
        def __get__(self):
            return  InputTextTrackList.__new__(InputTextTrackList, self)
        
    def dump(self):
        lib.quicktime_dump(self.ptr)
        
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
        
cdef class QuicktimeWriter(QuicktimeReader):
    def __init__(self, bytes path):
        self.ptr = lib.quicktime_open(path, 0, 1)
        

def open(path, mode = 'r'):
    if mode == 'r':
        return QuicktimeReader(path)
    elif mode == 'w':
        return QuicktimeWriter(path)
    else:
        raise ValueError("unknown mode %s" % str(mode))