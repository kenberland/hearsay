class FixRoommateTypo < ActiveRecord::Migration
  def up
    execute "UPDATE tag_categories set category='roommates' where category='roomates'"
  end

  def down
    execute "UPDATE tag_categories set category='roommates' where category='roommates'"
  end
end
