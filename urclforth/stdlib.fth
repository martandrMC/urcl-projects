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

: bump ( n -- )
	here @ + here !
;

: const ( n w -- )
	word create iconst , ,
;

: var ( w -- )
	word create ivar , 0 ,
;

: array ( n w -- )
	word create ivar , bump
;

: >name ( d -- s )
	1+ dup
	1+ swap
	@ mlength & 1+
;

: >str ( a -- s )
	dup @ swap 1+ swap
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

: ," ( w* -- )
	[ ' " , ] dup
	last @ >cfa exec
	! bump drop
; runimm

: ?words ( -- )
	last @ begin
		dup >name tell
		10 out @ dup 0 = 
	unl loop drop
;

: ?stack ( -- )
	dsp@ begin tds over u>
	if dup @ . 32 out 1+
	loop drop
;

: ?free ( -- n )
	edr here @ -
;

( Welcome message )
?free mark done
var msg1 ," Type `?words` for a list of words you can call"
var msg2 ," Type `?stack` to read the contents of the stack"
var msg4 ," Postfix notation! Try this out: `1 2 + 3 * .`"
var msg3 ," Define words using `: name contents ;`"
4 array msgs msgs
msg1 over ! 1+
msg2 over ! 1+
msg3 over ! 1+
msg4 over ! 1+
drop

." URCL Forth v3.6 (" . ."  free / " edr . ."  total)" 10 out
msgs rng 4 % + @ >str tell 10 out
done
