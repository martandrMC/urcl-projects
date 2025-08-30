: cfaof word find >cfa ;
: unlist word find hide ;
: char word drop @ ;

: mark
	free @ last @ word create ifunc ,
	litn litn , , litn last , litn ! ,
	litn litn , , litn free , litn ! ,
	litn exit ,
;
