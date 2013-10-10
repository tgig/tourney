require 'test_helper'

class TourneysControllerTest < ActionController::TestCase
  setup do
    @tourney = tourneys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tourneys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tourney" do
    assert_difference('Tourney.count') do
      post :create, tourney: { description: @tourney.description, enddate: @tourney.enddate, name: @tourney.name, startdate: @tourney.startdate }
    end

    assert_redirected_to tourney_path(assigns(:tourney))
  end

  test "should show tourney" do
    get :show, id: @tourney
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tourney
    assert_response :success
  end

  test "should update tourney" do
    patch :update, id: @tourney, tourney: { description: @tourney.description, enddate: @tourney.enddate, name: @tourney.name, startdate: @tourney.startdate }
    assert_redirected_to tourney_path(assigns(:tourney))
  end

  test "should destroy tourney" do
    assert_difference('Tourney.count', -1) do
      delete :destroy, id: @tourney
    end

    assert_redirected_to tourneys_path
  end
end
