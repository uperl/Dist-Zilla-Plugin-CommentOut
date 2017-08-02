use 5.014;
use Test2::V0 -no_srand => 1;
use Dist::Zilla::Plugin::CommentOut;
use Test::DZil;

subtest defaults => sub {

  my $tzil = Builder->from_config(
    { dist_root => 'corpus/Foo-Bar-Baz' },
    {
      add_files => {
        'source/dist.ini' => simple_ini({},
          [ 'GatherDir'  => {} ],
          [ 'ExecDir'    => {} ],
          [ 'CommentOut' => {} ],
        )
      }
    }
  );
  
  $tzil->build;
  
  ok 1;
  
  my($script) = grep { $_->name =~ /^bin/ } @{ $tzil->files };
  my($pm)     = grep { $_->name =~ /^lib/ } @{ $tzil->files };
  my($test)   = grep { $_->name =~ /^t\// }   @{ $tzil->files };

  is($script->content, <<'EOF', 'script content');
#!/usr/bin/env perl

use strict;
use warnings;
#use lib '../bin'; # dev-only

print "hi there";

EOF

  is($pm->content, <<'EOF', 'pm content');
package Foo::Bar::Baz;

use strict;
use warnings;

#our $VERSION = 'dev'; # dev-only

1;
EOF
  
};

subtest remove => sub {

  my $tzil = Builder->from_config(
    { dist_root => 'corpus/Foo-Bar-Baz' },
    {
      add_files => {
        'source/dist.ini' => simple_ini({},
          [ 'GatherDir'  => {} ],
          [ 'ExecDir'    => {} ],
          [ 'CommentOut' => { remove => 1 } ],
        )
      }
    }
  );
  
  $tzil->build;
  
  ok 1;
  
  my($script) = grep { $_->name =~ /^bin/ } @{ $tzil->files };
  my($pm)     = grep { $_->name =~ /^lib/ } @{ $tzil->files };
  my($test)   = grep { $_->name =~ /^t\// }   @{ $tzil->files };

  is($script->content, <<'EOF', 'script content');
#!/usr/bin/env perl

use strict;
use warnings;


print "hi there";

EOF

  is($pm->content, <<'EOF', 'pm content');
package Foo::Bar::Baz;

use strict;
use warnings;



1;
EOF
  
};

done_testing
