require 'test_helper'

class DisplaysheetsControllerTest < ActionController::TestCase
  setup do
    @displaysheet = displaysheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:displaysheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create displaysheet" do
    assert_difference('Displaysheet.count') do
      post :create, displaysheet: { grade: @displaysheet.grade, student: @displaysheet.student }
    end

    assert_redirected_to displaysheet_path(assigns(:displaysheet))
  end

  test "should show displaysheet" do
    get :show, id: @displaysheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @displaysheet
    assert_response :success
  end

  test "should update displaysheet" do
    put :update, id: @displaysheet, displaysheet: { grade: @displaysheet.grade, student: @displaysheet.student }
    assert_redirected_to displaysheet_path(assigns(:displaysheet))
  end

  test "should destroy displaysheet" do
    assert_difference('Displaysheet.count', -1) do
      delete :destroy, id: @displaysheet
    end

    assert_redirected_to displaysheets_path
  end
end
