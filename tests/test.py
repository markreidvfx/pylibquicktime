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

print q.video_tracks[0].compression.dump()

q2 = libquicktime.open("test2.mov", 'w')
q2.name = "weee"
print q2.name
q2.close()