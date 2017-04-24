STRUC tmfmt
.ct:		resd	1	; C time (seconds since the Epoch)
.sc:		resd	1	; seconds
.mn:		resd	1	; minutes
.hr:		resd	1	; hours
.yr:		resd	1	; year
.hm:		resd	1	; hour of the meridian (1-12)
.mr:		resd	1	; meridian (0 for AM)
.wd:		resd	1	; day of the week (Sunday=0, Saturday=6)
.w1:		resd	1	; day of the week (Monday=1, Sunday=7)
.dy:		resd	1	; day of the month
.mo:		resd	1	; month (one-based)
.ws:		resd	1	; week of the year (Sunday-based)
.wm:		resd	1	; week of the year (Monday-based)
.wi:		resd	1	; week of the year according to ISO 8601:1988
.yi:		resd	1	; year for the week according to ISO 8601:1988
.yd:		resd	1	; day of the year
.ce:		resd	1	; century (zero-based)
.cy:		resd	1	; year of the century
.zo:		resd	1	; time zone offset
.zi:		resb	6	; time zone identifier
.tz:		resb	10	; time zone name
ENDSTRUC
