#!/usr/bin/env python
# encoding=utf8  
# -*- coding: utf8  -*-

# MAKE A VIDEO FROM THE PERIODIC SAVE IMAGES
# https://superuser.com/questions/249101/how-can-i-combine-30-000-images-into-a-timelapse-movie
#

from os import listdir
import shutil
import subprocess

SOURCE_FOLDER 	= "/Users/coreysi/Documents/CP+B/CreateTech/2017/images"
OUTPUT_FILE 	= "/Users/coreysi/Documents/CP+B/CreateTech/2017/babel_long.mkv"





from os.path import isfile, join
onlyfiles = [f for f in listdir(SOURCE_FOLDER) if isfile(join(SOURCE_FOLDER, f))]

for f in onlyfiles:
	orig = f

	# extract the number
	num = f.split("_")[-1].split(".")[0].zfill(3)

	# clean up
	if orig[-3:] == "png":
		new = orig.replace("png", "jpg")
		shutil.move(SOURCE_FOLDER+"/"+orig, SOURCE_FOLDER+"/"+new)
	elif orig[0] == "-":
		new = orig[1:]
		shutil.move(SOURCE_FOLDER+"/"+orig, SOURCE_FOLDER+"/"+new)
	else:
		new = "".join(f.split("_")[0:-1])+"-"+num+".jpg"
		shutil.move(SOURCE_FOLDER+"/"+orig, SOURCE_FOLDER+"/"+new)
	
	# 
	print orig, num, new
	



# CMD="ffmpeg -pattern_type glob -i '$SOURCE_FOLDER/*.png' -c:v libx264 -pix_fmt yuv420p $OUTPUT_FILE"

# CMD="ffmpeg -pattern_type glob -i $SOURCE_FOLDER/*.png -c:v libx264 -pix_fmt yuv420p $OUTPUT_FILE"

# CMD="ffmpeg -pattern_type glob -i \"*.png\" -c:v libx264 $OUTPUT_FILE"

# cmd="cd {};ffmpeg -framerate 120 -start_number 1 -i img-%03d.png {}".format(SOURCE_FOLDER, OUTPUT_FILE)
cmd="ffmpeg -framerate 300 -start_number 1 -i img-%03d.jpg {}".format(OUTPUT_FILE)

print cmd
# subprocess.call(cmd, shell=True)