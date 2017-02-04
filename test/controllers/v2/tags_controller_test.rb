require 'test_helper'

class V2::TagsControllerTest < ActionDispatch::IntegrationTest
  test 'the tag endpoint responds to get' do
    hearsay_xml_http_request(:get, tags_url, {})
    assert_response 200
  end
  test 'the tag list has proper tags and ids' do
    hearsay_xml_http_request(:get, tags_url, {})
    tag = random_tag
    category = Tag.find(tag).tag_category

    assert_equal(tag,
                 JSON.parse(response.body).select{
                   |c| c['category'] == category.category
                 }.first['tags']
                   .select {
                   |t| t['tag'] == Tag.find(tag).tag
                 }.first['id'])
  end

  test 'the tag list has the category name and category id' do
    hearsay_xml_http_request(:get, tags_url, {})
    category = random_tag_category_obj
    assert_equal(1,
                 JSON.parse(response.body).select{
                   |c| c['category'] == category.category
                 }.count)
    assert_equal(category.id,
                 JSON.parse(response.body).select{
                   |c| c['category'] == category.category
                 }.first['category_id'])
  end
end
