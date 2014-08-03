
from libc.stdint cimport uint8_t, uint32_t, int64_t

cdef extern from "lqt.h" :
    ctypedef struct quicktime_t:
        pass
    
    ctypedef struct lqt_codec_info_t:
        pass
    
    cdef enum lqt_compression_id_t:
        pass
    
    ctypedef struct lqt_compression_info_t:
        lqt_compression_id_t id
        int flags
        int global_header_len
        uint8_t * global_header
        
        int bitrate
        
        # Audio format
        int samplerate
        int num_channels
        
        # Video format
        int width
        int height
        int pixel_width
        int pixel_height
        int colormodel
        int video_timescale
    
    quicktime_t* quicktime_open(char *filename, int rd, int wr)
    int quicktime_close(quicktime_t *file)     
    
    int quicktime_dump(quicktime_t *file)
    
    
    #quicktime.h
    
    # Video
    int quicktime_video_tracks(quicktime_t *file)
    int quicktime_video_width(quicktime_t *file, int track)
    int quicktime_video_height(quicktime_t *file, int track)
    int lqt_video_time_scale(quicktime_t * file, int track)
    double quicktime_frame_rate(quicktime_t *file, int track)
    long quicktime_video_length(quicktime_t *file, int track)
    int64_t lqt_video_duration(quicktime_t * file, int track)
    int quicktime_video_depth(quicktime_t *file, int track)
    
    int quicktime_supported_video(quicktime_t *file, int track)    
    
    #  Audio
    int quicktime_audio_tracks(quicktime_t *file)
    int quicktime_track_channels(quicktime_t *file, int track)
    long quicktime_sample_rate(quicktime_t *file, int track)
    long quicktime_audio_length(quicktime_t *file, int track)
    int quicktime_audio_bits(quicktime_t *file, int track)
        
    # Text
    int lqt_text_tracks(quicktime_t *file)     
    
    # MetaData
    char* quicktime_get_copyright(quicktime_t *file)
    char* quicktime_get_name(quicktime_t *file)
    char* quicktime_get_info(quicktime_t *file)
    char * lqt_get_album(quicktime_t * file)
    char * lqt_get_artist(quicktime_t * file)
    char * lqt_get_genre(quicktime_t * file)
    char * lqt_get_track(quicktime_t * file)
    char * lqt_get_comment(quicktime_t *file)
    char * lqt_get_author(quicktime_t *file)
    unsigned long lqt_get_creation_time (quicktime_t *file)

    void quicktime_set_copyright(quicktime_t *file, char *string)
    void quicktime_set_name(quicktime_t *file, char *string)
    void quicktime_set_info(quicktime_t *file, char *string)
    void lqt_set_album(quicktime_t *file, char *string)
    void lqt_set_artist(quicktime_t *file, char *string)
    void lqt_set_genre(quicktime_t *file, char *string)
    void lqt_set_track(quicktime_t *file, char *string)
    void lqt_set_comment(quicktime_t *file, char *string)
    void lqt_set_author(quicktime_t *file, char *string)


    # Timecodes
    int LQT_TIMECODE_DROP
    int LQT_TIMECODE_24HMAX
    int LQT_TIMECODE_NEG_OK
    int LQT_TIMECODE_COUNTER
    
    void lqt_add_timecode_track(quicktime_t *file, int track, uint32_t flags, int framerate)
    void lqt_write_timecode (quicktime_t *file, int track, uint32_t timecode)
    int lqt_has_timecode_track (quicktime_t *file, int track, uint32_t *flags, int *framerate)
    int lqt_read_timecode (quicktime_t *file, int track, uint32_t *timecode)

    char *lqt_get_timecode_tape_name(quicktime_t *file, int track)
    void lqt_set_timecode_tape_name(quicktime_t *file, int track, const char *tapename)
    int  lqt_get_timecode_track_enabled(quicktime_t *file, int track)
    void lqt_set_timecode_track_enabled(quicktime_t *file, int track, int enabled)
    
    # Codecs
    lqt_codec_info_t **lqt_query_registry(int audio, int video, int encode, int decode)
    lqt_codec_info_t **lqt_audio_codec_from_file(quicktime_t *file, int track)
    lqt_codec_info_t **lqt_video_codec_from_file(quicktime_t *file, int track)
    void lqt_destroy_codec_info (lqt_codec_info_t **info)
    void lqt_dump_codec_info(lqt_codec_info_t *info)
    
    # Compression Info
    void lqt_compression_info_copy(lqt_compression_info_t * dst, const lqt_compression_info_t * src)
    lqt_compression_info_t * lqt_get_audio_compression_info(quicktime_t * file, int track)
    lqt_compression_info_t * lqt_get_video_compression_info(quicktime_t * file, int track)
    void lqt_compression_info_dump(lqt_compression_info_t * ci)
    lqt_compression_info_t * lqt_get_video_compression_info(quicktime_t * file, int track)
    void lqt_compression_info_free(lqt_compression_info_t * info)
    