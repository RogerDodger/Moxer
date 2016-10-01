package Moxer::Controller::Draft;
use Moxer::Base 'Moxer::Controller';

# This action will render a template
sub test ($c) {
   my $cards = $c->db->query(q{
         select * from printsx where set_id = 166 and rarity = 'Mythic Rare'
      })->hashes;

   $c->render("draft/test", cards => $cards);
}

1;
