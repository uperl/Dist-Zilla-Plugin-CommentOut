# Dist::Zilla::Plugin::CommentOut [![Build Status](https://secure.travis-ci.org/plicease/Dist-Zilla-Plugin-CommentOut.png)](http://travis-ci.org/plicease/Dist-Zilla-Plugin-CommentOut)

Comment out code in your scripts and modules

# SYNOPSIS

    [CommentOut]
    id = dev-only

# DESCRIPTION

This plugin comments out lines of code in your Perl scripts or modules with
the provided identification.  This allows you to have code in your development
tree that gets commented out before it gets shiped by [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) as a
tarball.

The motiviation was to be able to have scripts in my dist like this:

    #!/usr/bin/env perl
    
    use strict;
    use warnings;
    use lib::findbin '../lib';  # dev-only
    use App::MyApp;

Which is totally usable from the development tree.  Then I can put this in my
`dist.ini`:

    [SetScriptShebang]
    [CommentOut]

And my script will be converted to:

    #!perl
    
    use strict;
    use warnings;
    #use lib::findbin '../lib';  # dev-only
    use App::MyApp;

Which is the right thing for CPAN.  Since lines are commented out, line numbers
are retained.

# PROPERTIES

## id

The comment id to search for.

## remove

Remove lines instead of comment them out.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
