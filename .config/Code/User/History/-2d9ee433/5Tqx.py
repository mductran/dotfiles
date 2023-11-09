a = "0229ecefd5da5d3f996f343fc2a083a77e938ed63b95b54514e9ab3c3127577e"

print(len(a))
print()

appear = []
i = 0

while (i+3 < len(a)):
    segment = a[i:i+3]

    print(segment, segment in appear)
    if segment not in appear:
        appear.append(segment)
        print(segment)
    i += 1

print()
print(len(appear))