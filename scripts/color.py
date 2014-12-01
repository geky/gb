#!/usr/bin/env python2

import sys


def main():
    rgb = sys.argv[1:4]
    rgb = map(int, rgb)
    rgb = [a >> 3 for a in rgb]
    gb = (rgb[2] << 10) | (rgb[1] << 5) | rgb[0]
    print "16'h%x" % gb

if __name__=="__main__":
    main()
