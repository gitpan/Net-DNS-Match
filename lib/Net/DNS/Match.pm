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

our $VERSION = '0.04';

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
	
	# map out by highest level root first
	# count how many .'s appear in the fqdn
	my @tmp = map { [ ($_ =~ tr/\.//), $_ ] } @$array;
	
	# sort by highest tld down, then by fqdn
	@tmp = sort { $a->[0] <=> $b->[0] || $a->[1] cmp $b->[1] } @tmp;
	
	foreach my $e (@tmp){
        push(@{$self->{'list'}},$e->[1]);
    }
}

# ref:
# http://www.perltutorial.org/perl-binary-search.aspx
# http://www.openbookproject.net/thinkcs/python/english3e/list_algorithms.html#binary-search
sub match {
    my $self   = shift;
    my $thing  = shift;

    return 0 unless($self->{'list'});
    my $local_list = $self->{'list'};
        
    my $lb = 0;
    my $ub = $#{$local_list};
         
    if($ub == 0){
        my $tmp = @{$local_list}[0];
        return $thing if($thing =~ /\.?$tmp$/);
    }
    
    while($lb != $ub){      
        # probe should be in the middle of the region
        my $mid = int(($lb + $ub) / 2);
        
        # fetch the item at that pos
        my $item = @{$local_list}[$mid];
        
        # How does the probed item compare to the target?
        
        # found it
        return $thing if($thing =~ /\.?$item$/);
        if($item gt $thing){
            # use the upper half of the region next time
            $lb = $mid + 1;
        } else {
            # use the lower half
            $ub = $mid;
        }
    }    
    return 0;
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
