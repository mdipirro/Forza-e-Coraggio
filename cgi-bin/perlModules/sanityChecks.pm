#!/usr/bin/perl -w
 
=head1 insert_html_entities
 
 Parametri	  		    : 	0) scalare: testo
 Valori di ritorno		: 	stringa senza caratteri < > " &
 Descrizione		 	:	Questa funzione riceve in input una stringa contenente,
                   			possibilmente, i caratteri < > " &. Ritorna la stessa stringa
							con le entità Unicode al posto dei caratteri menzionati.
 
=cut
sub insert_html_entities {
	my $str		= $_[0];
	$str 		=~ s/</&#x3C;/g;
	$str 		=~ s/>/&#x3E;/g;
	$str 		=~ s/\"/&#x22;/g;
	$str 		=~ s/\&/&#x26;/g;
	return $str; 
}

=head1 remove_html_entities
 
 Parametri	  		    : 	0) scalare: testo
 Valori di ritorno		: 	stringa con caratteri < > " &
 Descrizione		 	:	Questa funzione riceve in input una stringa contenente,
                   			possibilmente, le entità rappresentanti i caratteri < > " &. Ritorna la stessa stringa
							con senza le entità.
 
=cut
sub remove_html_entities {
	my $str		= $_[0];
	$str 		=~ s/&#x3C;/</g;
	$str 		=~ s/&#x3E;/>/g;
	$str 		=~ s/&#x22;/\"/g;
	$str 		=~ s/&#x26;/&/g;
	return $str; 
}


=head1 check_email
 
 Parametri	  		    : 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input una stringa e verifica se
 				        	è un indirizzo email valido. Ritorna true sse la stringa è
 				        	un indirizzo email valido.
 
=cut
sub check_email {
	return $_[0] =~ /[\w_\.\+\-]+@[\w_\.\+\-]+\.[\w_\.\+\-]+/;
}


=head1 check_telephone_number
 
 Parametri	  		    : 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input una stringa e verifica se
 				        	è un numero di telefono nel formato italiano valido. Il
 				        	numero può essere mobile o fisso. Ritorna true sse la stringa è
 					        un numero di telefono valido.
 
=cut
sub check_telephone_number {
	return $_[0] =~ /^(\+39|0039)?((3\d{2})(\d{6,9}))$|^(\+39|0039)?(((0\d{1,4}))(\d{5,10}))$/;
}


=head1 is_fixed_point
 
 Parametri	  	    	: 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input un numero e verifica che
 					        non sia decimale. Ritorna true sse il numero non è decimale.
 
=cut
sub is_fixed_point {
	return $_[0] =~ /^\d+$/;
}


=head1 is_floating_point
 
 Parametri	  	    	: 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input un numero e verifica che
 				        	sia decimale. Ritorna true sse il numero è decimale.
 
=cut
sub is_floating_point {
	return $_[0] =~ /^\d+\.\d+$/;
}


=head1 is_valid_date
 
 Parametri	  	    	: 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input una stringa rappresentante una
 				        	data in formato aaaa-mm-gg, gg-mm-aaaa o mm-gg-aaaa e verifica
							che sia ben formata rispetto a uno di questi tre formati e che
 				           	sia una data valida. Ritorna true sse è ben formata e valida.
 
=cut
sub is_valid_date {
	my $d, my $m, my $y; 								                # giorno, mese, anno
	my $dayRE 		= '(0[1-9]|[12][0-9]|3[01])';				        # espressione regolare per il giorno della data
	my $monthRE 	= '(0[1-9]|1[012])';             					# espressione regolare per il mese della data
	my $yearRE 		= '(19\d\d|20\d\d)'; 			            		# espressione regolare per l'anno della data
	my $separator	 = '[/-]'; 						                    # separatore
	my $regex1 		= "^$dayRE$separator$monthRE$separator$yearRE\$"; 	# espressione regolare per il formato gg-mm-aaaa
	my $regex2 		= "^$yearRE$separator$monthRE$separator$dayRE\$"; 	# espressione regolare per il formato aaaa-mm-gg
	if ($_[0] =~ /$regex1/) { # gg-mm-aaaa
		# ora $1 contiene il giorno, $2 il mese, $3 l'anno
		($y,$m,$d) = ($3,$2,$1); # swap
	}
	elsif ($_[0] =~ /$regex2/) { # aaaa-mm-gg
		# ora $1 contiene l'anno, $2 il mese, $3 il giorno
		($y,$m,$d) = ($1,$2,$3); #swap
	}
	else{
		return (0,undef); # data non ben formata
	} 
	
	# controlli per la validità 
	if($d==31 && ($m==4 || $m==6 || $m==9 || $m==11)){ # giorno 31 in un mese da 30 giorni
		return (0,undef);
	}
	elsif($d>=30 && $m==2){ # 30 o 31 febbraio
		return (0,undef);
	}
	elsif($m==2 && $d==29 && !($y%4==0 && ($y%100!=0 || $y%400==0))){ # 29 febbraio in un anno non bisestile
		return (0,undef);
	}
    else{ # data valida
    	return (1,$y.'-'.$m.'-'.$d);
    }
}


=head1 allow_text_only
 
 Parametri	  		    : 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input una stringa e controlla che sia
 				          	composta solo da caratteri alfabetici. Ritorna true sse la stringa
 					        è composta da soli caratteri alfabetici.
 
=cut
sub allow_text_only {
	return $_[0] =~ /^[a-zA-Z\s]+$/;
}


=head1 is_gender
 
 Parametri	  		    : 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input una stringa e controlla che 
 				        	sia M o F (le due lettere rappresentanti il sesso). Ritorna
 				        	true se è M o F, false altrimenti.
 
=cut
sub is_gender {
	return $_[0] =~ /^M$/ || $_[0] =~ /^F$/;
}


=head1 remove_separators
 
 Parametri	  	    	: 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare
 Descrizione		 	:	Questa funzione riceve in input una stringa e rimuove i 
 				          	caratteri -, \, /, spazio o tabulazione. Ritorna la stessa
 					        stringa senza questi caratteri.
 
=cut
sub remove_separators {
	my $text = $_[0];
	$text =~ s/[-\/\\\s]//g;
	return $text;
}

=head1 is_image

 Parametri	  		    : 	0) scalare: stringa da verificare
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione riceve in input una stringa e controlla che
 				        	finisca con 'jpg' o 'png'. Ritorna true se finisce con jpg o
 				        	png, false altrimenti.

=cut
sub is_image {
	return substr($_[0], -3) =~ /^jpg$/ || substr($_[0], -3) =~ /^png$/;
}


1;
