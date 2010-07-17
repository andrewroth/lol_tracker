require 'test_helper'

class GameBansControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_bans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_ban" do
    assert_difference('GameBan.count') do
      post :create, :game_ban => { }
    end

    assert_redirected_to game_ban_path(assigns(:game_ban))
  end

  test "should show game_ban" do
    get :show, :id => game_bans(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_bans(:one).to_param
    assert_response :success
  end

  test "should update game_ban" do
    put :update, :id => game_bans(:one).to_param, :game_ban => { }
    assert_redirected_to game_ban_path(assigns(:game_ban))
  end

  test "should destroy game_ban" do
    assert_difference('GameBan.count', -1) do
      delete :destroy, :id => game_bans(:one).to_param
    end

    assert_redirected_to game_bans_path
  end
end
