
from libc.stdint cimport uint32_t, int64_t

cdef extern from "lqt.h" :
    ctypedef struct  quicktime_t:
        pass
    
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
    
    #  Audio
    int quicktime_audio_tracks(quicktime_t *file)
    int quicktime_track_channels(quicktime_t *file, int track)
    long quicktime_sample_rate(quicktime_t *file, int track)
    long quicktime_audio_length(quicktime_t *file, int track)
    int quicktime_audio_bits(quicktime_t *file, int track)
        
    # Text
    int lqt_text_tracks(quicktime_t *file)     


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