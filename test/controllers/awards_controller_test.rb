require 'test_helper'

class AwardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @award = awards(:one)
  end

  test "should get index" do
    get awards_url
    assert_response :success
  end

  test "should get new" do
    get new_award_url
    assert_response :success
  end

  test "should create award" do
    assert_difference('Award.count') do
      post awards_url, params: { award: { address: @award.address, amount: @award.amount, city: @award.city, ein: @award.ein, filename: @award.filename, filer_ein: @award.filer_ein, name: @award.name, purpose: @award.purpose, state: @award.state, uploaded_at: @award.uploaded_at, zip: @award.zip } }
    end

    assert_redirected_to award_url(Award.last)
  end

  test "should show award" do
    get award_url(@award)
    assert_response :success
  end

  test "should get edit" do
    get edit_award_url(@award)
    assert_response :success
  end

  test "should update award" do
    patch award_url(@award), params: { award: { address: @award.address, amount: @award.amount, city: @award.city, ein: @award.ein, filename: @award.filename, filer_ein: @award.filer_ein, name: @award.name, purpose: @award.purpose, state: @award.state, uploaded_at: @award.uploaded_at, zip: @award.zip } }
    assert_redirected_to award_url(@award)
  end

  test "should destroy award" do
    assert_difference('Award.count', -1) do
      delete award_url(@award)
    end

    assert_redirected_to awards_url
  end
end
