use strict;
use vars qw($VERSION %IRSSI);

use strict;
use warnings;

use Time::HiRes qw(usleep nanosleep);

use Irssi;
$VERSION = '1.00';
%IRSSI = (
    authors     => 'Patric Schmitz',
    contact     => 'bzk0711@aol.com',
    name        => 'cells',
    description => 'draw cellular automaton.',
    license     => 'Public Domain',
    );

use constant NETWORK_TAG => 'saunaklub';
use constant CHANNEL => '#testing';

use constant OUTPUT_LINES => 192;
use constant OUTPUT_WIDTH => 100;
use constant TIMEOUT_MS => 200;

use constant SEED_PROB_PERC => 10;
use constant LIFE_STRING => 'swnc';
use constant DEAD_CHAR  => '-';
use constant LIFE_COLOR => '03';
use constant DEAD_COLOR => '02';

my $tag;
sub cells {
    my ($data) = @_;

    my $server = Irssi::server_find_tag(NETWORK_TAG);

    # construct output with colors
    my $outstring;

    for(my $c = 0 ; $c < length($data->{line}) ; $c++) {
        my $char = substr($data->{line}, $c, 1);
        if($char eq DEAD_CHAR) {
            $outstring .= "\cC".DEAD_COLOR.$char;
        }
        else {
            $outstring .= "\cC".LIFE_COLOR.$char;
        }
    }

    $server->command('msg ' . CHANNEL . ' ' . $outstring);

    # perform CA iteration
    my $oldstr = $data->{line};
    for(my $c = 0 ; $c < length($data->{line}) ; $c++) {
        my $length = length($oldstr);

        my $idL = ($c-1) % $length;
        my $idR = ($c+1) % $length;
        my $left  = not substr($oldstr, $idL, 1) eq DEAD_CHAR;
        my $mid   = not substr($oldstr, $c,   1) eq DEAD_CHAR;
        my $right = not substr($oldstr, $idR, 1) eq DEAD_CHAR;

        substr($data->{line}, $c, 1, DEAD_CHAR);
        if($left xor $right) {
            substr($data->{line}, $c, 1,
                   substr(LIFE_STRING, $data->{lifeIndex}, 1));
        }
    }

    $data->{lifeIndex} = ($data->{lifeIndex} + 1) % length(LIFE_STRING);

    if($data->{count} > 1) {
        $data->{count} = $data->{count} - 1;
        Irssi::timeout_add_once(TIMEOUT_MS, 'cells', $data);
    }
}

my $data;
$data->{count} = OUTPUT_LINES;
$data->{line} = DEAD_CHAR x OUTPUT_WIDTH;
$data->{lifeIndex} = 0;

for(my $c = 0 ; $c < length($data->{line}) ; $c++) {
    if(rand(100) < SEED_PROB_PERC) {
        substr($data->{line}, $c, 1,
               substr(LIFE_STRING, $data->{lifeIndex}, 1));
    }
}
$data->{lifeIndex}++;

$data->{tag} = Irssi::timeout_add_once(TIMEOUT_MS, 'cells', $data);
