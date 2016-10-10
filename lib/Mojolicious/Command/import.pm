package Mojolicious::Command::import;

use Moxer::Base 'Mojolicious::Command';
use Moxer::CardData;

sub run ($self) {
   my $conf = $self->app->config;
   if (-e $conf->{cdfn}) {
      system('psql', '-f', $conf->{cdfn}, $conf->{db}{name});
   }
   else {
      Moxer::CardData::load($self->app->pg);
   }
}

1;
