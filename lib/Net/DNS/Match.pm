package Net::DNS::Match;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Net::DNS::Match ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

sub new {
	my $class = shift;
	my $args = shift;
	
	my $self = {};
	bless($self,$class);
	
	return $self;
}

sub add {
	my $self = shift;
	my $array = shift;
	
	$array = [ $array ] unless(ref($array) eq 'ARRAY');
	
	foreach my $e (@$array){
		my $first = lc(substr($e,0,1));
		push(@{$self->{'list'}->{$first}},$e);
	}
}

sub match {
	my $self   = shift;
	my $things = shift;
	
	$things = [ $things ] unless(ref($things) eq 'ARRAY');
	
	my $matches;
	
	foreach my $thing (@$things){
	   # first we have to see if this exact domain is in the list
	   if($self->_match($thing)){
	   	   push(@$matches,$thing);
	   } else {  
		   # if not, we check to see if the subseqent tiered domains
		   # are in the list somewhere
		   my @bits = split(/\./,$thing);
	       my $domain = $bits[$#bits-1].'.'.$bits[$#bits];
	       if(my $ret = $self->_match($domain)){
	           push(@$matches,$thing);
	       }

	   }
	   
	}
	
	return($matches);
}

sub _match {
	my $self = shift;
	my $thing = shift;
	
	my $first = _get_first($thing);
	return unless(exists($self->{'list'}->{$first}));
	 
    my $local_list = $self->{'list'}->{$first};
    foreach my $m (@$local_list){
        return 1 if($thing =~ /\.?$m$/);
    }
}
	 

sub _get_first {
	my $thing = shift;
	return unless($thing);
	
	return lc(substr($thing,0,1));
}
	

1;
__END__

=head1 NAME

Net::DNS::Match - Perl extension for testing domains against another list of domains (similar to Net::Patricia but for FQDNs)

=head1 SYNOPSIS

  use Net::DNS::Match;
  use Data::Dumper;
  my $addr = 'img.yahoo.com';

  my $match = Net::DNS::Match->new();
  $match->add([
      'yahoo.com',
      'google.com',
      'www.facebook.com',
   ]);
 
 die Dumper($match->match($addr));

=head1 DESCRIPTION

This module was initially created to test a list of domains against a whitelist (eg: the Alexa top 1000 list). 

=head2 EXPORT

None by default.

=head1 SEE ALSO

collectiveintel.net

github.com/collectiveintel

=head1 AUTHOR

Wesley Young, E<lt>wes@barely3am.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Wesley Young

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
