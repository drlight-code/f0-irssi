use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';
%IRSSI = (
    authors     => 'Patric Schmitz',
    contact     => 'bzk0711@aol.com',
    name        => '1337',
    description => 'l33d0r1z3 messages.',
    license     => 'Public Domain',
    );

sub l33d0r1z3 {
    my $emitted_signal = Irssi::signal_get_emitted();
    my ($msg, $param1, $param2) = @_;
    
    $msg =~ s/[aA]/4/g;
    $msg =~ s/[bB]/8/g;
    $msg =~ s/[eE]/3/g;
    $msg =~ s/[iI]/1/g;
    $msg =~ s/[lL]/7/g;
    $msg =~ s/[oO]/0/g;
    $msg =~ s/s/z/g;
    $msg =~ s/S/Z/g;

    Irssi::signal_continue($msg, $param1, $param2 );
}

Irssi::signal_add_first('send text', 'l33d0r1z3');
