#!/usr/bin/env python3
import sys
import re

matches = [
"^\\s*@defprim(i?)\\s+(\\\"[^\\\"\\s]+\\\")\\s+([^\\\"\\s]+)\\s*$",
"^\\s*@defforth(i?)\\s+(\\\"[^\\\"\\s]+\\\")\\s+([^\\\"\\s]+)\\s*$",
"^\\s*@defconst(i?)\\s+(\\\"[^\\\"\\s]+\\\")\\s+([^\\\"\\s]+)\\s+([^\\s]+)\\s*$",
"^\\s*@defvar(i?)\\s+(\\\"[^\\\"\\s]+\\\")\\s+([^\\\"\\s]+)\\s+([^\\s]+)\\s*$"
]

counts = [3, 3, 4, 4]

replacements = [
""".head_{label}
dw [ {last} 0x{length:02X} {name} ]
.code_{label}
dw [ .exec_{label} ]
nop
.exec_{label}
""",
""".head_{label}
dw [ {last} 0x{length:02X} {name} ]
.code_{label}
dw [ .run_proc ]
""",
""".head_{label}
dw [ {last} 0x{length:02X} {name} ]
.code_{label}
dw [ .run_const {value} ]

""",
""".head_{label}
dw [ {last} 0x{length:02X} {name} ]
.code_{label}
dw [ .run_var {value} ]

"""
]

def main(ipath, opath):
	with open(ipath, "r") as ifile:
		lines = ifile.readlines()

	with open(opath, "w") as ofile:
		last = "0"
		for line in lines:
			for i, match in enumerate(matches):
				result = re.match(match, line)
				if not result or result.lastindex < counts[i]:
					continue
				length = len(result.group(2)) - 3
				if result.group(1) == "i":
					length += 0x80
				if counts[i] == 4:
					value = result.group(4)
				else:
					value = ""
				ofile.write(replacements[i].format(
					label = result.group(3),
					name = result.group(2),
					length = length,
					value = value,
					last = last
				))
				last = ".head_{}".format(result.group(3))
				break
			else:
				ofile.write(line)

if __name__ == "__main__":
	if len(sys.argv) != 3:
		main("urclforth_macro.urcl", "urclforth.urcl")
	else:
		main(sys.argv[1], sys.argv[2])
