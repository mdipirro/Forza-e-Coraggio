#!/usr/bin/perl -w
use CGI::Session();

use constant USER => 'user'; #costante per il nome del parametro di sessione contente lo username dell'utente loggato
 
=head1 check_login
 
 Parametri	  			: 	Nessuno
 Valori di ritorno		: 	scalare (dal valore booleano)
 Descrizione		 	:	Questa funzione ritorna true sse è presente una sessione che
 							indica l'avvenuto login.
 
=cut
sub check_login(){
	return defined(get_session_param(USER));
} 


=head1 create_session
 
 Parametri	  			: 	0) oggetto CGI
							1) scalare (username)
 Valori di ritorno		: 	sessione (oggetto CGI::Session) e cookie associato (da memorizzare)
 Descrizione		 	:	Questa funzione riceve in input una stringa e crea una sessione
 							impostando un parametro con chiave contenuta nella costante USER
 							e valore contenuto nel parametro. Il parametro USER contiene 
							quindi lo username dell'utente loggato. La funzione ritorna la
							sessione creata (I valore ritornato) e il cookie associato da 
							memorizzare (II valore ritornato).
 
=cut
sub create_session {
	my $page 		= $_[0];
	my $username	= $_[1];
	my $session 	= new CGI::Session(undef,$page,{Directory=>'/tmp'});
	my $cookie 		= $page->cookie(CGISESSID => $session->id);
	$session->param(USER, $username);
	return ($session, $cookie);
} 


=head1 get_session_param
 
 Parametri	  			: 	0) scalare: nome del parametro da ottenere
 Valori di ritorno		: 	scalare
 Descrizione		 	:	Questa funzione riceve in input una stringa e ritorna il valore
							del parametro avente come chiave paramName. Se la 
							sessione è scaduta, non ha parametri o non contiene parametri con
							la chiave desiderata viene ritornato il valore undef.
 
=cut
sub get_session_param {
	my $session	= CGI::Session->load() or return undef; # se non si riesce a caricare la sessione è richiesto nuovamente il login
	if ($session->is_expired || $session->is_empty) { 
		return undef;
	} # if
	else {
		return $session->param($_[0]);
	} # else
}

=head1 destroy_session
 
 Parametri	  			: 	nessuno
 Valori di ritorno		: 	nessuno
 Descrizione		 	:	Questa funzione distrugge la sessione corrente.
 
=cut
sub destroy_session {
	my $session	= CGI::Session->load();
	if (defined($session)) {
		$session->close();
		$session->delete();
		$session->flush();
	}
} 

1;
