class AddLibraryTags < ActiveRecord::Migration
  def up
    add_column :tags, :is_library_tag, :boolean
    add_index :tags, :is_library_tag, name: 'index_is_library_tag_on_tags'
#  id |   category    |        created_at         |        updated_at         
# ----+---------------+---------------------------+---------------------------
#   1 | finance       | 2016-03-18 04:21:51.31038 | 2016-03-18 04:21:51.31038
#   2 | roomates      | 2016-03-18 04:21:51.31038 | 2016-03-18 04:21:51.31038
#   3 | work          | 2016-03-18 04:21:51.31038 | 2016-03-18 04:21:51.31038
#   4 | relationships | 2016-03-18 04:21:51.31038 | 2016-03-18 04:21:51.31038
#   5 | school        | 2016-03-18 04:21:51.31038 | 2016-03-18 04:21:51.31038
#   6 | sports        | 2016-03-18 04:21:51.31038 | 2016-03-18 04:21:51.31038
    execute <<EOD
INSERT into tags (tag, tag_category_id, is_library_tag, created_at, updated_at) values
('thrifty',1,true,now(),now()),
('spendthrift',1,true,now(),now()),
('tight',1,true,now(),now()),

('messy',2,true,now(),now()),
('unfair',2,true,now(),now()),
('loud',2,true,now(),now()),

('late',3,true,now(),now()),
('lazy',3,true,now(),now()),
('trustworthy',3,true,now(),now()),

('selfish',4,true,now(),now()),
('cold',4,true,now(),now()),
('loving',4,true,now(),now()),

('straight-As',5,true,now(),now()),
('class-clown',5,true,now(),now()),
('popular',5,true,now(),now()),
('mean',5,true,now(),now()),

('ball hog',6,true,now(),now()),
('mvp',6,true,now(),now()),
('sore loser',6,true,now(),now())

EOD
  end

  def down
    remove_column :tags, :is_library_tag
  end
end
