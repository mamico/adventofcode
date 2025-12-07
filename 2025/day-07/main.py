import sys

def main():
    lines = open(sys.argv[1]).readlines()
    pos = lines[0].index("S")
    part2 = timelines(pos, lines[1:])
    print(f"PART2 {part2}")

CACHE = {}

def cache(fun):
    def w(p, lines):
        key = f"{p}-{len(lines)}"
        if key in CACHE:
            return CACHE[key]
        val = fun(p, lines)
        CACHE[key] = val
        return val
    return w

@cache
def timelines(p, lines):
    if p <0 or p >= len(lines[0]):
        return 0
    if len(lines) == 1:
        return 1
    if lines[0][p] == "^":
       return timelines(p-1, lines[1:]) + timelines(p+1, lines[1:])
    return timelines(p, lines[1:])


if __name__ == "__main__":
    main()