#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More tests => 1;

require Struct::Diff;
use JSON::Patch qw();

my $patch = JSON::Patch::diff(
    Struct::Diff::diff(
        {foo => ['bar']},
        {foo => ['bar', 'baz']}
    )
);
is_deeply(
    $patch,
    [
        {op => 'add', path => '/foo/1', value => 'baz'}
    ],
    'convert from Struct::Diff to JSON::Patch when single arg used'
);

