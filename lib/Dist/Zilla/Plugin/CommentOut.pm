use strict;
use warnings;
use 5.014;

package Dist::Zilla::Plugin::CommentOut {

  # ABSTRACT: Comment out code in your scripts and modules

=head1 SYNOPSIS

 [CommentOut]
 id = dev-only

=head1 DESCRIPTION

This plugin comments out lines of code in your Perl scripts or modules with
the provided identification.  This allows you to have code in your development
tree that gets commented out before it gets shiped by L<Dist::Zilla> as a
tarball.

The motiviation was to be able to have scripts in my dist like this:

 #!/usr/bin/env perl
 
 use strict;
 use warnings;
 use lib::findbin '../lib';  # dev-only
 use App::MyApp;

Which is totally usable from the development tree.  Then I can put this in my
C<dist.ini>:

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

=head1 PROPERTIES

=head2 id

The comment id to search for.

=head2 remove

Remove lines instead of comment them out.

=cut

  use Moose;
  with (
    'Dist::Zilla::Role::FileMunger',
    'Dist::Zilla::Role::FileFinderUser' => {
      default_finders => [ ':ExecFiles', ':InstallModules' ],
    },
  );

  use namespace::autoclean;
  
  has id => (
    is      => 'rw',
    isa     => 'Str',
    default => 'dev-only',
  );
  
  has remove => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
  );
  
  sub munge_files
  {
    my($self) = @_;
    $DB::single = 1;
    $self->munge_file($_) for @{ $self->found_files };
    return;
  }
  
  sub munge_file
  {
    my ($self, $file) = @_;
    
    return if $file->is_bytes;
    
    $self->log("commenting out @{[ $self->id ]} in @{[ $file->name ]}");
    
    my $content = $file->content;
    
    my $id = $self->id;
    
    if($self->remove)
    { $content =~ s/^(.*?#\s*$id\s*)$//mg }
    else
    { $content =~ s/^(.*?#\s*$id\s*)$/#$1/mg }
    
    $file->content($content);
    return;
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
