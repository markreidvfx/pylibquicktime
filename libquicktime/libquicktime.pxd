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

cdef class OutputVideoTrack(InputVideoTrack):
    pass

cdef class OutputAudioTrack(InputAudioTrack):
    pass

cdef class OutputTextTrack(InputTextTrack):
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

cdef class OutputVideoTrackList(InputVideoTrackList):
    pass

cdef class OutputAudioTrackList(InputAudioTrackList):
    pass

cdef class OutputTextTrackList(InputTextTrackList):
    pass

cdef class CodecList(object):
    cdef lib.lqt_codec_info_t **a_ptr
    cdef lib.lqt_codec_info_t **v_ptr
    
    cdef object find_audio_encoder_by_compression_id(self, CompressionInfo compression)
    cdef object find_video_encoder_by_compression_id(self, CompressionInfo compression)

cdef class CompressionInfo(object):
    cdef lib.lqt_compression_info_t *ptr

cdef class Codec(object):
    cdef lib.lqt_codec_info_t *ptr
    
cdef class Packet(object):
    cdef lib.lqt_packet_t ptr
