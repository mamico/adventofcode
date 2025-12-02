import sys

def invalid(b, e):
	for i in range(b, e + 1):
		s = str(i)
		if s[:len(s) // 2] == s[len(s) // 2:]:
			yield i


def invalid_2(b, e):
	for i in  range(b, e + 1):
		invalid = False
		s = str(i)
		for j in range(len(s)//2, 0, -1):
			if len(s) % j == 0:
				invalid = all(map(lambda it: s[it:it+j] == s[:j], range(j, len(s), j)))
				if invalid:
					break
		if invalid:
			yield i

view_content = open(sys.argv[1]).read().strip()
a = view_content.split(",")
a = map(lambda it: it.split("-"), a)
a = map(lambda it: sum(invalid(int(it[0]), int(it[1]))), a)
print("PART 1 - ", sum(a))

a = view_content.split(",")
a = map(lambda it: it.split("-"), a)
a = map(lambda it: sum(invalid_2(int(it[0]), int(it[1]))), a)
print("PART 2 - ", sum(a))
