#!perl

use strict;
use warnings FATAL => 'all';

use JSON;
use JSON::Patch qw(patch);
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

        next if ($t->{disabled});
        #next unless ($count == 67);

        my $test = JSON->new->pretty->encode($t);
        diag "$file .... $count/" . scalar @{$tests} if ($ENV{DEBUG});


        eval { JSON::Patch::patch($t->{doc}, $t->{patch}) };
        if ($@) {
            if (exists $t->{error}) {
                ok(1);
            } else {
                diag $test;
                fail("Unexpected exception: $@");
            }

            next;
        } else {
            if (exists $t->{error}) {
                diag $test;
                fail("Should be error: $t->{error}");
                next;
            }
        }

        unless (exists $t->{expected}) {
            pass($t->{comment});
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
