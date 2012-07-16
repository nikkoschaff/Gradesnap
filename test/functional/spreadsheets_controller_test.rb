require 'test_helper'

class SpreadsheetsControllerTest < ActionController::TestCase
  setup do
    @spreadsheet = spreadsheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spreadsheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spreadsheet" do
    assert_difference('Spreadsheet.count') do
      post :create, spreadsheet: { name: @spreadsheet.name, num_q: @spreadsheet.num_q }
    end

    assert_redirected_to spreadsheet_path(assigns(:spreadsheet))
  end

  test "should show spreadsheet" do
    get :show, id: @spreadsheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spreadsheet
    assert_response :success
  end

  test "should update spreadsheet" do
    put :update, id: @spreadsheet, spreadsheet: { name: @spreadsheet.name, num_q: @spreadsheet.num_q }
    assert_redirected_to spreadsheet_path(assigns(:spreadsheet))
  end

  test "should destroy spreadsheet" do
    assert_difference('Spreadsheet.count', -1) do
      delete :destroy, id: @spreadsheet
    end

    assert_redirected_to spreadsheets_path
  end
end
