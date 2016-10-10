package Moxer;
use Moxer::Base 'Mojolicious';

use Moxer::Pg;

# This method will run once at server start
sub startup ($self) {
   $self->moniker('moxer');

   $self->plugin('Moxer::Config');
   $self->plugin('PlainRoutes', { autoname => 1 });

   $self->plugin(EPRenderer => {
      name     => 'epm',
      template => {
         tag_start => '{{',
         tag_end   => '}}',
      },
   });

   $self->helper(pg => sub {
      state $pg = Moxer::Pg->new($self->config('db'));
   });

   $self->helper(cardurl => sub {
      "//gatherer.wizards.com/Handlers/Image.ashx?multiverseid=$_[1]&type=card";
   });

   $self->helper(db => sub { $self->pg->db });
}

1;
