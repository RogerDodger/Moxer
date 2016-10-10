package Moxer::CardData;

use Moxer::Base -strict;

use Encode;
use File::Basename;
use Mojo::JSON qw/encode_json decode_json/;
use Moxer::QueryBuilder qw/:all/;
use Term::ProgressBar;

binmode STDOUT, ':encoding(UTF-8)';

# my $url = "https://mtgjson.com/json/CNS-x.json.zip";
my $url = "https://mtgjson.com/json/AllSets-x.json.zip";
my $filez = "site/" . basename $url;
my $file = $filez =~ s/\.zip$//r;

my %fields = (
   sets => {
      file => [qw/id name gathererCode oldCode magicCardsInfoCode releaseDate
                  border type block booster/],
      db =>   [qw/id name code_gatherer code_old code_mci released
                  border type block booster/],
   },
   cards => {
      file => [qw/layout name names manaCost cmc colors colorIdentity
                  type supertypes types subtypes text power toughness loyalty/],
      db   => [qw/layout name names mana_cost cmc colors color_identity
                  type supertypes types subtypes body power toughness loyalty/],
   },
   prints => {
      file => [qw/multiverseid variations id rarity originalType originalText
                  flavor artist number watermark border timeshifted
                  reserved releaseDate starter mciNumber source/],
      db   => [qw/card_id set_id multiverseid variations uid rarity type
                  body flavor artist number watermark border timeshifted
                  reserved released starter mci_number source/],
   },
);

sub load ($pg) {
   if (!-e $filez) {
      say "Downloading card data...";
      system('wget', '-O' , $filez, $url) == 0
         or die "Failed to download card data\n";
   }

   if (!-e $file) {
      system('unzip', '-d', 'site/', $filez) == 0
         or die "Failed to unzip card data\n";
   }

   say "Reading $file...";
   open my $fh, '<', $file;
   my $data = decode_json do { local $/ = <$fh> };
   close $fh;

   my $db = $pg->db;
   my $parse_set = sub {
      my $set = shift;
      return if $set->{onlineOnly};

      printf "[%s] %s\n", $set->{code}, $set->{name};
      $set->{id} = $set->{code};
      $set->{booster} = encode_json $set->{booster};
      my $sid = _upsert($db, $set, 'sets', 'id');

      my $progress = Term::ProgressBar->new(scalar $set->{cards}->@*);
      for my $card ($set->{cards}->@*) {
         $card->{uid} = $card->{id};
         $card->{$_} //= 0 for qw/timeshifted reserved starter source/;

         my $cid = _upsert($db, $card, 'cards', 'name');
         my $pid = _upsert($db, $card, 'prints', 'uid', $cid, $sid);

         $card->{rulings} //= [];
         for my $ruling ($card->{rulings}->@*) {
            eval {
               $db->query(
                  "insert into rulings (card_id, body, created) values (?,?,?)",
                  $cid, $ruling->{text}, $ruling->{date});
            }
         }

         $progress->update;
      }
   };

   say "Loading card data into database...";
   # Coerce single set hash to have same structure as multi set
   if ($data->{code}) {
      $parse_set->($data);
   }
   else {
      my @sets = values $data->%*;
      for my $set (sort { $a->{releaseDate} cmp $b->{releaseDate} } @sets) {
         $parse_set->($set);
      }
   }
}

sub _upsert ($db, $data, $table, $id, @fks) {
   state $querys = {};

   $querys->{$table} //= {
      update => update_ret_id($table, $fields{$table}{db}, $id),
      insert => insert_ret_id($table, $fields{$table}{db}),
   };

   my @cols = $data->@{$fields{$table}{file}->@*};

   my $hash = $db->query($querys->{$table}{update}, @fks, @cols, $data->{$id})->hash
           || $db->query($querys->{$table}{insert}, @fks, @cols)->hash;

   $hash->{id};
}

1;
