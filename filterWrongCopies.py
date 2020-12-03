import sys

gff3Repet = open(sys.argv[1],"r").readlines()
for line in gff3Repet:
	start = int(line.split("\t")[8].split(" ")[1])
	end = int(line.split("\t")[8].split(" ")[2].split(";")[0])
	if "con48_roo" in line:
		if not (start >= 1139 and end <= 1560):
			print line.rstrip("\n")
	elif "con33_17-6" in line:
		if not (start >= 900 and end <= 1300):
			print line.rstrip("\n")
	elif "con20_HMS-Beagle;" in line:
		if not (start >= 640 and end <= 1550):
			print line.rstrip("\n")
	elif "con25_opus" in line:
		if not (start >= 6150 and end <= 6450):
			print line.rstrip("\n")
	elif "con17_Max-element" in line:
		if not (start >= 370 and end <= 1900):
			print line.rstrip("\n")
	elif "DBGP_TART-B" in line:
		if not (start >= 10 and end <= 290):
			print line.rstrip("\n")
	elif "con42_mdg1" in line:
		if not (start >= 8855 and end <= 9260):
			if not (start >= 3270 and end <= 3460):
				if not (start >= 3660 and end <= 3800):
					if not (start >= 1200 and end <= 1350):
						if not (start >= 1550 and end <= 1640):
							if not (start >= 5 and end <= 110):
								print line.rstrip("\n")
	elif "con2_Dbuz-Kepler" in line:
		if not (start >= 475 and end <= 580):
			print line.rstrip("\n")
	elif "DBGP_Dana-Tom" in line:
		if not (start >= 610 and end <= 935):
			print line.rstrip("\n")
	elif "con8_UnFmcl025_RLX-comp" in line: #Copia1
		if not (start >= 1 and end <= 170):
			print line.rstrip("\n")
	else:
		if "con10_Rt1cA" not in line:
			if "con10_Rt1cB" not in line:
				if "UnFUnClUnAlig_RIX-comp_TEN" not in line:
					print line.rstrip("\n")
