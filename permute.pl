use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';
%IRSSI = (
    authors     => 'Patric Schmitz',
    contact     => 'flavi0@openmailbox.org',
    name        => 'permute',
    description => 'Permutes inner characters in all words.',
    license     => 'Public Domain',
    );

sub permute_string {
    my $out = "";
    my $string = @_[0];

    my $length = length($string);
    for (1..$length) {
        $out .= substr($string, int(rand(length($string))), 1, "");
    }

    return $out;
}

sub permute_middle {
    my $string = @_[0];
    my $out = "";

    my $first  = substr($string, 0, 1);
    my $middle = substr($string, 1, length($string)-2);
    my $last   = substr($string, length($string)-1, 1);
    
    $out .= $first;
    $out .= permute_string($middle);
    $out .= $last;

    return $out;
}

sub permute_line {
    my $line = $_[0];
    my $out = "";
    
    my @splitlist = split(" +", $line);
    foreach my $item (@splitlist) {
        $out .= permute_middle($item) . " "
    }

    return $out;
}

sub permute_message {
    my $emitted_signal = Irssi::signal_get_emitted();
    my ($msg, $param1, $param2) = @_;

    $msg = permute_line($msg);
    
    Irssi::signal_continue($msg, $param1, $param2 );
}

Irssi::signal_add_first('send text', 'permute_message');
