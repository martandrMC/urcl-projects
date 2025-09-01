: ' word find >cfa ;
: delist word find hide ;
: char word drop @ ;

: if   runimm litn brz , free @ 0 , ;
: then runimm free @ over - swap ! ;
: else runimm litn jmp , free @ 0 , swap [ ' then , ] ;

: mark
	last @ free @ word create 0 , 0 , , ,
	patch dup @ free ! 1+ @ last !
;
