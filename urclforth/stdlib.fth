: ' word find >cfa ;

: delist word find hide ;

: char word drop @ ;

: >name
	1+ dup
	1+ swap
	@ 15 & 1+
;

: if runimm
	litn brz ,
	here @ 0 ,
;

: unl runimm
	litn not ,
	[ ' if , ]
;

: else runimm
	litn jmp ,
	here @ 0 ,
	swap [ ' end , ]
;

: end runimm
	here @ over - swap !
;

: begin runimm here @ ;

: loop runimm
	litn jmp ,
	swap here @ - ,
	[ ' end , ]
;

: self runimm
	last @ >cfa ,
;

: words
	last @ begin
		dup >name tell
		10 out @ dup 0 = 
	unl loop drop
;

: free
	edr here @ -
;

: mark
	last @ here @ word create 0 , 0 , , ,
	patch dup @ here ! 1+ @ last !
;
