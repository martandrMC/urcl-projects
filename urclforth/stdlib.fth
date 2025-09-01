: unlist word find hide ;
: char word drop @ ;

: mark
	last @ free @ word create 0 , 0 , , ,
	patch dup @ free ! 1+ @ last !
;
