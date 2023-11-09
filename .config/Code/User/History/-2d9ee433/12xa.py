a = "0229ecefd5da5d3f996f343fc2a083a77e938ed63b95b54514e9ab3c3127577e"

appear = []
i = 0

while (i+3 < len(a)):
    segment = a[i:i+3]
    if segment not in appear:
        appear.append(segment)
    else:
        print("duplicate: ", segment)
    i += 1