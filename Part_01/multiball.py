#!/usr/bin/env python3
import sys
from datetime import datetime
import random
    
minX = -4.0
maxX = 4.0
minY = minX
maxY = maxX
minZ = minX
maxZ = maxX
minRadius = 0.8
maxRadius = 2.0



def file_header(): 
    return '#usda 1.0\n'

def offset_string(xoffset, yoffset, zoffset):
    #"My name is {fname}, I'm {age}".format(fname = "John", age = 36)
    return '\n\tdouble3 xformOp:translate = ({x}, {y}, {z})\n\tuniform token[] xformOpOrder = ["xformOp:translate"]\n'.format(x=xoffset, y=yoffset, z=zoffset)
    
def color_string(red, green, blue):
    return '\n\t\tcolor3f[] primvars:displayColor = [({r}, {g}, {b})]'.format(r=red, g=green, b=blue)
    
def radius_string(radius):
    return '\n\t\tdouble radius = {rad}'.format(rad = radius)

def build_item(id, reference_file, geometry_name, xoffset, yoffset, zoffset, radius, red, green, blue):
    tmp_string = '\nover "' + id + '" (\n\tprepend references = @./' + reference_file + '.usd@\n)\n{'
    
    if any([xoffset != 0, yoffset != 0, zoffset != 0]):
        tmp_string = tmp_string + offset_string(xoffset, yoffset, zoffset)        
    
    tmp_string = tmp_string + '\n\tover "' + geometry_name + '"\n\t{'

    tmp_string = tmp_string + color_string(red, green, blue)
    tmp_string = tmp_string + radius_string(radius)

    tmp_string = tmp_string + "\n\t}"
    
    tmp_string = tmp_string + "\n}"
    return tmp_string

def write_file(string, path):
    with open(path, 'bw+') as f:
        f.write(string.encode('utf-8'))
        f.close()

if __name__ == "__main__":    
    if len(sys.argv) == 3:
        count = int(sys.argv[1])
        destination_file_name = sys.argv[2]
    elif len(sys.argv) == 2:
        count = int(sys.argv[1])
        destination_file_name = "multiball_" + datetime.now().strftime("%Y%m%dT%H%M%S")
    else:
        count = 5
        destination_file_name = "multiball_" + datetime.now().strftime("%Y%m%dT%H%M%S")

    origin_marker = build_item("blueSphere", "sphere_base", "sphere", 0, 0, 0, 1, 0, 0, 1)

    file_contents = file_header() + origin_marker

    for x in range(count):
        file_contents = file_contents + build_item("sphere_" + "{id}".format(id=x), "sphere_base", "sphere", random.uniform(minX, maxX), random.uniform(minY, maxY), random.uniform(minZ, maxZ), random.uniform(minRadius, maxRadius), random.random(), random.random(), random.random())
    print(file_contents)
    write_file(file_contents, destination_file_name + ".usd")
