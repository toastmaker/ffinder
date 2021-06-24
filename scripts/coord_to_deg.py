#!/usr/bin/env python
from astropy.coordinates import SkyCoord
import sys

ra_, dec_=sys.argv[1], sys.argv[2]
ra_, dec_=sys.argv[1], sys.argv[2]
c  = SkyCoord(ra_,dec_)
print("{0} {1}".format(c.ra.deg, c.dec.deg))
