require 'test_helper'

class ReceiversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receiver = receivers(:one)
  end

  test "should get index" do
    get receivers_url
    assert_response :success
  end

  test "should get new" do
    get new_receiver_url
    assert_response :success
  end

  test "should create receiver" do
    assert_difference('Receiver.count') do
      post receivers_url, params: { receiver: { address: @receiver.address, city: @receiver.city, ein: @receiver.ein, filename: @receiver.filename, name: @receiver.name, state: @receiver.state, uploaded_at: @receiver.uploaded_at, zip: @receiver.zip } }
    end

    assert_redirected_to receiver_url(Receiver.last)
  end

  test "should show receiver" do
    get receiver_url(@receiver)
    assert_response :success
  end

  test "should get edit" do
    get edit_receiver_url(@receiver)
    assert_response :success
  end

  test "should update receiver" do
    patch receiver_url(@receiver), params: { receiver: { address: @receiver.address, city: @receiver.city, ein: @receiver.ein, filename: @receiver.filename, name: @receiver.name, state: @receiver.state, uploaded_at: @receiver.uploaded_at, zip: @receiver.zip } }
    assert_redirected_to receiver_url(@receiver)
  end

  test "should destroy receiver" do
    assert_difference('Receiver.count', -1) do
      delete receiver_url(@receiver)
    end

    assert_redirected_to receivers_url
  end
end
