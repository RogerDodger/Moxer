package Moxer::QueryBuilder;

use Moxer::Base 'Exporter';

our @EXPORT_OK = qw/insert insert_ret_id update update_ret_id/;
our %EXPORT_TAGS = ( all => \@EXPORT_OK  );

sub insert ($table, $fields) {
   qq{
      INSERT INTO $table
         (${\ join ', ', @$fields })
      VALUES
         (${\ join ', ', map { '?' } @$fields })
   }
}

sub insert_ret_id {
   insert(@_) . ' returning id';
}

sub update ($table, $fields, $id) {
   qq{
      UPDATE $table SET
         ${\ join ',', map { "$_ = ?" } @$fields }
      WHERE
         "$id" = ?
   }
}

sub update_ret_id {
   update(@_) . 'returning id';
}

1;
