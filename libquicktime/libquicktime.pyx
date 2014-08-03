
from libc.stdint cimport uint32_t
cimport lib

#cdef lib.lqt_codec_info_t **audio_encoders =  lib.lqt_query_registry(1, 0, 1, 0)
#cdef lib.lqt_codec_info_t **video_encoders =  lib.lqt_query_registry(0, 1, 1, 0)

cdef class Track(object):

    def __cinit__(self, Quicktime qt = None, int index = 0):
        self.qt = qt
        self.index = 0
        
    def __init__(self):
        raise TypeError("%s cannot be instantiated from Python" %  self.__class__.__name__)
    
# Input Tracks

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
        
    property tape_name:
        def __get__(self):
            cdef char* name= lib.lqt_get_timecode_tape_name(self.qt.ptr, self.index)
            if name:
                return name
            
    property timecode:
        def __get__(self):
            cdef uint32_t timecode = 0
            cdef int result
            
            result = lib.lqt_read_timecode(self.qt.ptr, self.index, &timecode)
            if result:
                return timecode
    
    property compression:
        def __get__(self):
            cdef CompressionInfo compression = CompressionInfo.__new__(CompressionInfo)
            compression.ptr = lib.lqt_get_video_compression_info(self.qt.ptr, self.index)
            if compression.ptr:
                return compression
    
    def __repr__(self):
        return '<av.%s #%d, %dx%d %f fps at 0x%x>' % (
            self.__class__.__name__,
            self.index,
            self.width,
            self.height,
            self.frame_rate,
            id(self),
        )

cdef class InputAudioTrack(Track):
    
    property channels:
        def __get__(self):
            return lib.quicktime_track_channels(self.qt.ptr, self.index)
    property sample_rate:
        def __get__(self):
            return lib.quicktime_sample_rate(self.qt.ptr, self.index)
    property length:
        def __get__(self):
            return lib.quicktime_audio_length(self.qt.ptr, self.index)
    property bits:
        def __get__(self):
            return lib.quicktime_audio_bits(self.qt.ptr, self.index)
        
    property compression:
        def __get__(self):
            cdef CompressionInfo compression = CompressionInfo.__new__(CompressionInfo)
            compression.ptr = lib.lqt_get_audio_compression_info(self.qt.ptr, self.index)
            if compression.ptr:
                return compression
        
    def __repr__(self):
        return '<av.%s  %d, %d samples at %dHz at 0x%x>' % (
            self.__class__.__name__,
            self.index,
            self.length,
            self.sample_rate,
            id(self),
        )

cdef class InputTextTrack(Track):
    pass

# Output Tracks

cdef class OutputVideoTrack(InputVideoTrack):
    pass

cdef class OutputAudioTrack(InputAudioTrack):
    pass

cdef class OutputTextTrack(InputTextTrack):
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
    
    def __repr__(self):
        return repr(list(self))
        
# Input TrackLists
  
cdef class InputVideoTrackList(TrackList):
    
    cdef _get_track(self, int index):
        return InputVideoTrack.__new__(InputVideoTrack, self.qt, index)
        
    cdef int _get_len(self):
        return lib.quicktime_video_tracks(self.qt.ptr)

cdef class InputAudioTrackList(TrackList):
    cdef _get_track(self, int index):
        return InputAudioTrack.__new__(InputAudioTrack, self.qt, index)
        
    cdef int _get_len(self):
        return lib.quicktime_audio_tracks(self.qt.ptr)
    
cdef class InputTextTrackList(TrackList):
    cdef _get_track(self, int index):
        return InputTextTrack.__new__(InputTextTrack, self.qt, index)
        
    cdef int _get_len(self):
        return lib.lqt_text_tracks(self.qt.ptr)

# Output TrackLists
    
cdef class OutputVideoTrackList(InputVideoTrackList):
    
    cdef _get_track(self, int index):
        return OutputVideoTrack.__new__(OutputVideoTrack, self.qt, index)

cdef class OutputAudioTrackList(InputAudioTrackList):
    cdef _get_track(self, int index):
        return OutputAudioTrack.__new__(OutputAudioTrack, self.qt, index)

cdef class  OutputTextTrackList(InputTextTrackList):
    cdef _get_track(self, int index):
        return OutputTextTrack.__new__(OutputTextTrack, self.qt, index)
    
cdef class CompressionInfo(object):
    def __cinit__(self):
        self.ptr = NULL
    def __init__(self):
        raise TypeError("%s cannot be instantiated from Python" %  self.__class__.__name__)
    
    def dump(self):
        lib.lqt_compression_info_dump(self.ptr)
    
    def __dealloc__(self):
        if self.ptr:
            lib.lqt_compression_info_free(self.ptr)
            
    
cdef class Codec(object):
    def __cinit__(self):
        self.ptr = NULL
        
    def __init__(self):
        raise TypeError("%s cannot be instantiated from Python" %  self.__class__.__name__)

cdef class Quicktime(object):

    def __cinit__(self):
        self.ptr = NULL
        
    def close(self):
        lib.quicktime_close(self.ptr)
        
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
        
    property copyright:
        def __get__(self):        
            cdef char* value = lib.quicktime_get_copyright(self.ptr)
            if value:
                return value
    property name:
        def __get__(self):
            cdef char* value = lib.quicktime_get_name(self.ptr)
            if value:
                return value
    property info:
        def __get__(self):
            cdef char *value = lib.quicktime_get_info(self.ptr)
            if value:
                return value
    property album:
        def __get__(self):
            cdef char *value = lib.lqt_get_album(self.ptr)
            if value:
                return value
    property artist:
        def __get__(self):
            cdef char *value = lib.lqt_get_artist(self.ptr)
            if value:
                return value
    property genre:
        def __get__(self):
            cdef char *value = lib.lqt_get_genre(self.ptr)
            if value:
                return value
    property track:
        def __get__(self):
            cdef char *value
            value = lib.lqt_get_track(self.ptr)
            if value:
                return value
    property comment:
        def __get__(self):
            cdef char *value = lib.lqt_get_comment(self.ptr)
            if value:
                return value
    property author:
        def __get__(self):
            cdef char *value = lib.lqt_get_author(self.ptr)
            if value:
                return value
    property creation_time:
        def __get__(self):
            return lib.lqt_get_creation_time(self.ptr)

    def dump(self):
        lib.quicktime_dump(self.ptr)
        
        
cdef class QuicktimeWriter(QuicktimeReader):
    def __init__(self, bytes path):
        self.ptr = lib.quicktime_open(path, 0, 1)
        
    def copy_setting(self, Quicktime not None):
        pass
        
    property video_tracks:
        def __get__(self):
            return OutputVideoTrackList.__new__(OutputVideoTrackList, self)
        
    property audio_tracks:
        def __get__(self):
            return OutputVideoTrackList.__new__(OutputAudioTrackList, self)
    
    property text_tracks:
        def __get__(self):
            return  OutputVideoTrackList.__new__(OutputTextTrackList, self)
        
    property name:
        def __get__(self):
            return super(QuicktimeWriter, self).name
        def __set__(self, bytes value):
            lib.quicktime_set_name(self.ptr, value)

def open(path, mode = 'r'):
    if mode == 'r':
        return QuicktimeReader(path)
    elif mode == 'w':
        return QuicktimeWriter(path)
    else:
        raise ValueError("unknown mode %s" % str(mode))