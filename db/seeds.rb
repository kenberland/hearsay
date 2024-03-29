require 'yaml'

class SeedMe
  attr_accessor :b

  def initialize
    @b = binding
  end

  def seeds
    $seeds ||= YAML.load(File.read(Rails.root.join('db', 'seeds.yml')))
  end

  def make_tags_for_category(category)
    seeds[category.category].each do |tag|
      make_tag(category, tag)
    end
  end

  def make_tag(category, tag)
    Tag.find_or_create_by(tag: tag, tag_category_id: category.id, is_library_tag: true, moderation_state: 1, phone_number_registration_id: 1)
  end

  def seed
    seeds.keys.each do |category|
      b.local_variable_set category.to_sym, TagCategory.find_or_create_by(category: category)
      make_tags_for_category(b.eval(category))
    end
    PhoneNumberRegistration.create(device_phone_number: '12125551212', device_uuid: 'deadbeefdeadbeef', verification_state: 1, verification_code: 'abcd')
  end
end

SeedMe.new.seed

