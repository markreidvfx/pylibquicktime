import libquicktime

test = "test.mov"
q = libquicktime.open(test)

#q.dump()



print q.video_tracks
print q.audio_tracks
print q.text_tracks
print q.comment
print q.creation_time

print q.video_tracks[0].duration
print q.video_tracks[0].timecode
print q.video_tracks[0].tape_name

#print q.video_tracks[0].compression.dump()
print q.video_tracks[0].codec
print q.video_tracks[0].codec

q2 = libquicktime.open("test2.mov", 'w')
q2.name = "weee"

tape_name = "TAPE_001"

track = q2.add_video_track_compressed(q.video_tracks[0].compression)
track.add_timecode(24)
track.timecode = 90000
track.tape_name = tape_name

for packet in q.video_tracks[0].iter_packets():
    track.write_packet(packet)

q2.close()