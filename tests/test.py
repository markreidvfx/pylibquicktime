import libquicktime

test = "test.mov"
q = libquicktime.Quicktime(test)

q.dump()

print q.tape_names()
print q.timecode()
