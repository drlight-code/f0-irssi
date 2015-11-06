use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';
%IRSSI = (
    authors     => 'Patric Schmitz',
    contact     => 'bzk0711@aol.com',
    name        => 'Reverse Input',
    description => 'Reverts input lines.',
    license     => 'Public Domain',
    );

sub reverse {
    my $emitted_signal = Irssi::signal_get_emitted();
    my ($msg, $param1, $param2) = @_;
    
    $msg = reverse $msg;

    Irssi::signal_continue($msg, $param1, $param2 );
}

Irssi::signal_add_first('send text', 'reverse');
