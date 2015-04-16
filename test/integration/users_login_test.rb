require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:brandon)
	end

	test "login with invalid information" do
		get login_path #Render login path
		assert_template 'sessions/new' #verify new session form renders correctly
		post login_path, session: { email: "", password: "" } #post bogus login with invalid params
		assert_template 'sessions/new' #Re-render new session another page
		assert_not flash.empty? #Check that flash renders
		get root_path #Rendering another page
		assert flash.empty? #Verifying that the flash is not appearing
	end

	test "login with valid information followed by logout" do
		get login_path #render login path
		post login_path, session: { email: @user.email, password: 'password' } #post valid login information
		assert is_logged_in? #assert userid is not null
		assert_redirected_to @user #verify that user's page is rendered
		follow_redirect! #Verify single redirect response. If last not redirect, exception raised. Visits target page
		assert_template 'users/show' #re-render session
		assert_select "a[href=?]", login_path, count: 0 
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
		delete logout_path #issues a DELETE request to logout path
		assert_not is_logged_in?
		assert_redirected_to root_url
		# Simulate a user clicking logout in a second window.
		delete logout_path
		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path,			count: 0
		assert_select "a[href=?]", user_path(@user),	count: 0
	end

	test "login with remembering" do
		log_in_as(@user, remember_me: '1')
		assert_not_nil cookies['remember_token']
	end

	test "login without remembering" do
		log_in_as(@user, remember_me: '0')
		assert_nil cookies['remember_token']
	end
end