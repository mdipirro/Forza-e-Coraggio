#!/usr/bin/perl -w
use strict;
use XML::LibXML;
use XML::LibXSLT;
use List::MoreUtils;

use constant {
	# costanti contententi i path relativi per i files xml
	USERS_PATH 		    => "../data/utenti.xml",
	COMMENTS_PATH		=> "../data/commenti.xml", 
	EXERCISES_PATH 		=> "../data/esercizi.xml",
	PLANS_PATH 	    	=> "../data/piani.xml",
	PROFILE_PATH		=> "../public_html/xslt/profilo.xslt",
	EXERCISE_PATH		=> "../public_html/xslt/esercizi.xslt",
	GENERAL_PLAN_PATH   => "../public_html/xslt/pianiGenerale.xslt",
	PLAN_DETAILS_PATH   => "../public_html/xslt/pianiDettagli.xslt",
	CREATE_PLAN_PATH   	=> "../public_html/xslt/creaPiano.xslt",
	COMMENT_PATH		=> "../public_html/xslt/commenti.xslt",
	# costante per il path assoluto del sito
#	BASIC_URI           => "http://localhost:30080/tecweb/~mdipirro/", #path da casa
	BASIC_URI		    => "http://tecnologie-web.studenti.math.unipd.it/tecweb/~mdipirro/", #path unipd
	# costante per il path della cartella delle immagini di profilo
	IMAGES_PATH         => "../public_html/img/utenti/"
};


=head1 apply_xsl_stylesheet
 
     Parametri	  		: 	0) scalare: path del file XML
                            1) scalare: path del file XSLT
                            2) scalare: errore da mostrare se l'operazione non può essere portata a termine.
                            3) scalare: nome del parametro per XSLT
                            4) scalare: valore del parametro per XSLT
 Valori di ritorno		: 	Codice HTML della pagina da mostrare
 Descrizione		 	:	Questa funzione riceve applica una trasformata XSL ad un file 
							XML, e ritorna il codice HTML prodotto dalla trasformata.
							Eventuali parametri vanno specificati come hash e passati come
							terzo parametro.
 
=cut

sub apply_xsl_stylesheet {
	my $xml_path	=	$_[0];
	my $xslt_path	=	$_[1];
	my $error	    =	$_[2];
	my $paramName	=	$_[3];
	my $paramValue	=	$_[4];
	my $xslt 		= 	new XML::LibXSLT;
	# caricamento del file xml
	my $source 		= 	XML::LibXML->load_xml(location => $xml_path) 				 or &show_error($error);
	# caricamento del file xslt
	my $style_doc 	= 	XML::LibXML->load_xml(location => $xslt_path, no_cdata => 1) or &show_error($error);
	# parsing del foglio di stile
	my $stylesheet  = 	$xslt->parse_stylesheet($style_doc) 					     or &show_error($error);
	# applicazione della trasformata
	my $result	 	= 	$stylesheet->transform($source, XML::LibXSLT::xpath_to_string(
						    $paramName => $paramValue
					    ))								                             or &show_error($error);
	# codice html
	return $stylesheet->output_as_bytes($result);
}

=head1 show_error
 
 	Parametri		  		: 	0) scalare: errore da mostrare
    	                        1) scalare: possibile soluzione dell'errore da mostrare
 	Valori di ritorno		: 	Nessuno
 	Descrizione			 	:	Questa funzione riceve in input una stringa e reindirizza
 								alla pagina di errore, mostrando la stringa in input come
 								testo della pagina.
 
=cut
sub show_error {
	my $error		=	$_[0];
	my $error_res	=	$_[1];
	open(ERRORS_PAGE, '<../public_html/oops.html'); 
	my @lines 		= 	<ERRORS_PAGE>;
	close(ERRORS_PAGE);
	my $index		=	List::MoreUtils::first_index {$_ =~ /id="errore"/} @lines;
	$lines[$index]	=	"<h2>$error</h2>";
	if ($error_res ne "") {
		$index          =   List::MoreUtils::first_index {$_ =~ /<ul id="listaSoluzioni">/} @lines;
		$lines[$index]  =~ s/<ul id="listaSoluzioni">/<ul id="listaSoluzioni"><li>$error_res<\/li>/;
	}
	my $pattern		= "img\/dante.jpg";
	$index			= List::MoreUtils::first_index {$_ =~ /$pattern/} @lines;
	$lines[$index] 	=~ s/$pattern/..\/$pattern/;
	print "Content-type:text/html\n\n";
	print correct_paths(join('', @lines));
}

=head1 correct_paths

 	Parametri		  		: 	0) scalare: codice HTML di una pagina
 	Valori di ritorno		: 	Nessuno
 	Descrizione			 	:	Questa funzione riceve in input una stringa contenente codice
 								HTML e corregge i percorsi per adattarli al cambio di directory
 								(aggiunge ../ per i percorsi riferiti a public_html e rimuove
 								cgi-bin da quelli riferiti a cgi-bin.

=cut
sub correct_paths {
	my $html 		= $_[0];
	my @patterns	= (	"index.html", "pettorali.html", "dorsali.html", "spalle.html", "gambeGlutei.html",
						"addome.html", "bicipiti.html", "tricipiti.html", "css/stile.css", "img/banner2.jpg",
						"img/logo.png", "registrazione.html", "img/diff/facile.png", "img/diff/medio.png", "img/diff/difficile.png",
						"js/register.js", "js/login.js", "contatti.html");
	foreach my $pattern (@patterns) { # aggiungo ../
		$html 		=~ s/$pattern/..\/$pattern/g;
	}
	# rimuovo cgi_bin
	$html			=~ s/<a href="cgi-bin\//<a href="/g;
	$html 			=~ s/action="cgi-bin\//action="/g;
	return $html;
}

1;
