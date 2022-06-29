class UsersController < ApplicationController
  respond_to :html, :js, :json

  def get_users
    @users = User.where('LOWER(first_name) like ? OR LOWER(last_name) like ? OR LOWER(email) like ?', "%#{params[:search].downcase}%", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%").limit(10)
    @users = @users.where.not(id: current_user.id)

    render json: @users
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :nick, :location, :biography, :sex, :country, :birthdate, :avatar)
  end
end
