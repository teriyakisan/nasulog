class SessionsController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']

    if auth.info['email'].split('@')[1] == ENV['RESTRICT_DOMAIN']
      user = User.find_by(google_uid: auth[:uid])
      user = User.form_omniauth(auth) unless user
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "
        ドメインが#{ENV['RESTRICT_DOMAIN']}ではありません。正しいドメインでサインイン・ログインしてください
      "
      redirect_to root_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end
