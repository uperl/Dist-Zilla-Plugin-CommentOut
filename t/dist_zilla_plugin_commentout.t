use Test2::V0 -no_srand => 1;
use Dist::Zilla::Plugin::CommentOut;
use Test::DZil;

subtest defaults => sub {

  my $tzil = Builder->from_config(
    { dist_root => 'corpus/Foo-Bar-Baz' },
    {
      add_files => {
        'source/dist.ini' => simple_ini({},
          [ 'GatherDir' => {} ],
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

  note '[script]';
  note($script->content);

  note '[pm]';
  note($pm->content);
  
  note '[test]';
  note($test->content);
};

done_testing
