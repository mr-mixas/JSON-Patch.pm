#!perl -T

use strict;
use warnings FATAL => 'all';

use JSON;
use JSON::Patch qw(diff patch);

use Test::More;

sub run_tests_from_json_file {
    my $file = shift;

    open(my $fh, '<', $file) or die "Failed to open file '$file' ($!)";
    my $tests = do { local $/; <$fh> }; # load whole file
    close($fh);

    $tests = JSON->new->relaxed->decode($tests);

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $count = 0;

    for my $t (@{$tests}) {
        $count++;

        #next unless ($count == 60);

        next if ($t->{disabled});
        next if ($t->{error});
        next unless ($t->{doc} and $t->{expected} and $t->{patch});

        next if (
            ref $t->{patch} eq 'ARRAY' and
            @{$t->{patch}} and
            $t->{patch}->[0]->{op} eq 'test'
        );

        my $test = JSON->new->pretty->encode($t);
        diag "\n$file ... $count/" . scalar @{$tests} if ($ENV{DEBUG});

        my $patch = diff($t->{doc}, $t->{expected});

        # roundtrip
        eval { patch($t->{doc}, $patch) };
        if ($@) {
            fail($t->{comment});
            diag $test;
            diag Dumper $patch;
            next;
        }

        is_deeply($t->{doc}, $t->{expected}, $t->{comment}) || diag $test;
    }
}

for my $file (
    'xt/spec_tests.json',
    'xt/tests.json'
) {
    next unless (-e $file);
    run_tests_from_json_file($file);
}

done_testing();
