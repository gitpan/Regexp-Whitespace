
use Module::Build;

Module::Build->new(
  dist_name => 'Regexp-Whitespace',
  dist_version_from => 'lib/Regexp/Whitespace.pm',
  license => 'perl',
  author => 'Adriano Ferreira <ferreira@cpan.org>',
  requires => {
    'perl'                    => 5.008,
    'strict'                  => 0,
    'warnings'                => 0,
    'constant'                => 0,
    'if'                      => 0,

    'overload'                => 0,

    'Attribute::Memoize'      => 0,
    'Scalar::Util'            => 0,
    'Clone'                   => 0.28,
    'YAPE::Regex'             => 3.03,
    'charnames'               => 0,

  },
  build_requires => {
    'Test::More'              => 0,
    'ok'                      => 0, # from Test-use-ok
  },

  create_makefile_pl => 'traditional',
  create_readme => 1,

)->create_build_script;
