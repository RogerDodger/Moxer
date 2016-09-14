package Mojolicious::Command::import;

use Moxer::Base 'Mojolicious::Command';
use Moxer::CardData;

sub run ($self) {
   Moxer::CardData::load($self->app->pg);
}

1;
