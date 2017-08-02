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

# MOTIVATION

(with brief editorial)

I use perlbrew and/or perls installed in funny places and I'd like to be able to run
executables out of by git checkout tree without invoking `perl -Ilib` on
every call.  To that end I write something like this:

    #!/usr/bin/env perl
    
    use strict;
    use warnings;
    use lib::findbin '../lib';  # dev-only
    use App::MyApp;

That is lovely, except that the main toolchain installers EUMM and MB will
convert `/usr/bin/perl` but not `/usr/bin/env perl` to the correct perl
when the distribution is installed.  For some reason this is
a bug in everyone who uses this common convention but not the toolchain.  There
is a handy plugin `[SetScriptShebang]` that solves that problem but the 
`use lib::findbin '../lib';` is problematic because `../lib` relative to
the install location might not be ringht!  With this plugin I can comment it
fix both problems with these two Dist::Zilla plugins:

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
