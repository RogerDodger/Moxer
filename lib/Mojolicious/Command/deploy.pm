package Mojolicious::Command::deploy;

use Moxer::Base 'Mojolicious::Command';

use Bytes::Random::Secure;
use Cwd qw/abs_path/;
use DBI;
use File::Basename;
use IO::Prompt;
use Moxer::CardData;
use Moxer::Config;
use Moxer::Pg;
use YAML;

my $rng = Bytes::Random::Secure->new(NonBlocking => 1);

sub run ($self) {
   say "Deploying " . $self->app->moniker . '...';

   my %conf = $self->app->config->%*;
   my $cfn = $Moxer::Config::CONSTANTS{cfn};
   if (!-e $cfn || prompt("Config file exists. Overwrite it? [no] ") =~ /^y/i) {
      %conf = %Moxer::Config::DEFAULTS;
      $conf{secrets} = [ map $rng->bytes_hex(16), 1..10 ];

      $conf{db}{user} = $_ if length prompt("Database user [$ENV{USERNAME}] ");
      $conf{db}{password} = $_ if prompt("Database password [none] ", -e => '*');

      say "+ " . abs_path($cfn);
      YAML::DumpFile($cfn, \%conf);
      chmod 0600, $cfn;
   }

   $self->app->pg->migrations->migrate;
}

1;
