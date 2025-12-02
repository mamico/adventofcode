import sys

def invalid(b, e):
	for i in range(b, e + 1):
		s = str(i)
		if s[:len(s) // 2] == s[len(s) // 2:]:
			yield i


def invalid_2(b, e):
	for i in  range(b, e + 1):
		s = str(i)
		for j in range(len(s)//2, 0, -1):
			if len(s) % j == 0:
				if s == s[:j] * (len(s) // j):
					yield i
					break

view_content = open(sys.argv[1]).read().strip()

a = view_content.split(",")
a = map(lambda it: it.split("-"), a)
a = map(lambda it: sum(invalid(int(it[0]), int(it[1]))), a)
print("PART 1 - ", sum(a))

a = view_content.split(",")
a = map(lambda it: it.split("-"), a)
a = map(lambda it: sum(invalid_2(int(it[0]), int(it[1]))), a)
print("PART 2 - ", sum(a))
