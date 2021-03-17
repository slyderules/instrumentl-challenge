require 'test_helper'

class FilersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @filer = filers(:one)
  end

  test "should get index" do
    get filers_url
    assert_response :success
  end

  test "should get new" do
    get new_filer_url
    assert_response :success
  end

  test "should create filer" do
    assert_difference('Filer.count') do
      post filers_url, params: { filer: { address: @filer.address, city: @filer.city, ein: @filer.ein, filename: @filer.filename, name: @filer.name, state: @filer.state, uploaded_at: @filer.uploaded_at, zip: @filer.zip } }
    end

    assert_redirected_to filer_url(Filer.last)
  end

  test "should show filer" do
    get filer_url(@filer)
    assert_response :success
  end

  test "should get edit" do
    get edit_filer_url(@filer)
    assert_response :success
  end

  test "should update filer" do
    patch filer_url(@filer), params: { filer: { address: @filer.address, city: @filer.city, ein: @filer.ein, filename: @filer.filename, name: @filer.name, state: @filer.state, uploaded_at: @filer.uploaded_at, zip: @filer.zip } }
    assert_redirected_to filer_url(@filer)
  end

  test "should destroy filer" do
    assert_difference('Filer.count', -1) do
      delete filer_url(@filer)
    end

    assert_redirected_to filers_url
  end
end
