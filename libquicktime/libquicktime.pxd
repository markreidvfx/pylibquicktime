cimport lib

cdef class Quicktime(object):
    cdef lib.quicktime_t *ptr

cdef class QuicktimeReader(Quicktime):
    pass

cdef class QuicktimeWriter(QuicktimeReader):
    pass

cdef class Track(object):
    cdef readonly Quicktime qt
    cdef readonly int index
    
cdef class InputVideoTrack(Track):
    pass

cdef class InputAudioTrack(Track):
    pass

cdef class InputTextTrack(Track):
    pass

    
cdef class TrackList(object):
    cdef readonly Quicktime qt
    
    cdef _get_track(self, int index)
    cdef int _get_len(self)

cdef class InputVideoTrackList(TrackList):
    pass

cdef class InputAudioTrackList(TrackList):
    pass

cdef class InputTextTrackList(TrackList):
    pass
