import libquicktime

test = "test.mov"
q = libquicktime.open(test)

#q.dump()

print q.tape_names()
print q.timecode()

print q.video_tracks
print q.audio_tracks
print q.text_tracks

print q.video_tracks[0].duration
