(
	: def ( x y -- a b ) ... ;
	( x y ) = arguments | ( a b ) = results
	TOS is rightwards so use word as such: x y def

	d = dictionary entry
	x = execution token
	n = generic number
	a = generic address
	s = string; same as ( a n )
	w = word:
		as argument = taken from input
		as result = new entry created
)

: ' ( w -- x )
	word find >cfa
;

: delist ( w -- )
	word find hide
;

: char ( w -- n )
	word drop @
;

: >name ( d -- s )
	1+ dup
	1+ swap
	@ mlength & 1+
;

: if ( -- a )
	litn brz ,
	here @ 0 ,
; runimm

: unl ( -- a )
	litn not ,
	[ ' if , ]
; runimm

: end ( a -- )
	here @ over - swap !
; runimm

: else ( a -- a )
	litn jmp ,
	here @ 0 ,
	swap [ ' end , ]
; runimm

: begin ( -- a )
	here @
; runimm

: loop ( a -- )
	litn jmp ,
	swap here @ - ,
	[ ' end , ]
; runimm

: self ( -- )
	last @ >cfa ,
; runimm

: mark ( w -- w )
	last @ here @ word create 0 , 0 , , ,
	patch dup @ here ! 1+ @ last !
;

: " ( w* -- s )
	state @ if
		litn lits , here @ 0 ,
		begin inp dup 34 =
		unl , loop drop
		dup [ ' end , ] -!
	else
		here @ begin inp dup 34 =
		unl over ! 1+ loop drop
		here @ swap over -
	end
; runimm

: ." ( w* -- )
	state @ if [ ' " , ] litn tell ,
	else begin inp dup 34 =
	unl out loop drop end
; runimm

: ?words ( -- )
	last @ begin
		dup >name tell
		10 out @ dup 0 = 
	unl loop drop
;

: ?stack ( -- )
	dsp@ begin tds over >
	if dup @ . 32 out 1+
	loop drop
;

: ?free ( -- n )
	edr here @ -
;
