# NAME

JSON::Patch - JSON Patch (rfc6902) for perl structures

<a href="https://travis-ci.org/mr-mixas/JSON-Patch.pm"><img src="https://travis-ci.org/mr-mixas/JSON-Patch.pm.svg?branch=master" alt="Travis CI"></a>
<a href='https://coveralls.io/github/mr-mixas/JSON-Patch.pm?branch=master'><img src='https://coveralls.io/repos/github/mr-mixas/JSON-Patch.pm/badge.svg?branch=master' alt='Coverage Status'/></a>
<a href="https://badge.fury.io/pl/JSON-Patch"><img src="https://badge.fury.io/pl/JSON-Patch.svg" alt="CPAN version"></a>

# VERSION

Version 0.04

# SYNOPSIS

    use Test::More tests => 2;
    use JSON::Patch qw(diff patch);

    my $old = {foo => ['bar']};
    my $new = {foo => ['bar', 'baz']};

    my $patch = diff($old, $new);
    is_deeply(
        $patch,
        [
            {op => 'add', path => '/foo/1', value => 'baz'}
        ]
    );

    patch($old, $patch);
    is_deeply($old, $new);

# EXPORT

Nothing is exported by default.

# SUBROUTINES

## diff

Calculate patch for two arguments:

    $patch = diff($old, $new);

Convert [Struct::Diff](https://metacpan.org/pod/Struct::Diff) diff to JSON Patch when single arg passed:

    require Struct::Diff;
    $patch = diff(Struct::Diff::diff($old, $new));

## patch

Apply patch.

    patch($target, $patch);

# AUTHOR

Michael Samoglyadov, `<mixas at cpan.org>`

# BUGS

Please report any bugs or feature requests to `bug-json-patch at rt.cpan.org`,
or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=JSON-Patch](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=JSON-Patch). I will be
notified, and then you'll automatically be notified of progress on your bug as
I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc JSON::Patch

You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=JSON-Patch](http://rt.cpan.org/NoAuth/Bugs.html?Dist=JSON-Patch)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/JSON-Patch](http://annocpan.org/dist/JSON-Patch)

- CPAN Ratings

    [http://cpanratings.perl.org/d/JSON-Patch](http://cpanratings.perl.org/d/JSON-Patch)

- Search CPAN

    [http://search.cpan.org/dist/JSON-Patch/](http://search.cpan.org/dist/JSON-Patch/)

# SEE ALSO

[rfc6902](https://tools.ietf.org/html/rfc6902),
[Struct::Diff](https://metacpan.org/pod/Struct::Diff), [Struct::Diff::MergePatch](https://metacpan.org/pod/Struct::Diff::MergePatch)

# LICENSE AND COPYRIGHT

Copyright 2018 Michael Samoglyadov.

This program is free software; you can redistribute it and/or modify it under
the terms of either: the GNU General Public License as published by the Free
Software Foundation; or the Artistic License.

See [http://dev.perl.org/licenses/](http://dev.perl.org/licenses/) for more information.
