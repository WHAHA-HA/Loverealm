module Admin
  class UsersController < BaseController
    def index
      # TODO
    end

    def inactive
      condition = <<-SQL
        is_newbie = true OR
        (created_at <> ? AND
          date_trunc('day', created_at) = date_trunc('day', current_sign_in_at))
      SQL

      @inactive_users = User.where(condition, Date.today)

      if params[:from_date].present?
        from_date = Date.strptime(params[:from_date], "%m/%d/%Y")
        @inactive_users = @inactive_users.where('created_at > ?', from_date)
      end

      @inactive_users = @inactive_users.order('created_at DESC')

      respond_to do |format|
        format.html do
          @inactive_users = @inactive_users.page(params[:page]).per(20)
        end
        format.xls
      end
    end

    def banned
      @banned_users = User.banned.page(params[:page])
    end

    def unban
      @user = User.find(params[:id])
      @user.role = Role.find_by_name('users')

      if @user.save
        redirect_to :back, notice: 'User has been activated!'
      else
        redirect_to :back, error: 'Something went wrong.'
      end
    end

    def create_mentor
      @user = User.find(params[:id])
      @user.role = Role.find_by_name('mentor')
      if @user.save
        redirect_to admin_mentor_path(@user), notice: 'User is mentor now!'
        UserMailer.welcome_mentor(@user).deliver_now
      else
        redirect_to :back, 'Error while set user as mentor!'
      end
    end
  end
end
