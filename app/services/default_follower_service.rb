class DefaultFollowerService
  def initialize(user)
    @user = user
  end

  def assign
    if @user.following.blank?
      User.suggested_users(@user).limit(10).each do |user|
        @user.following << user
      end
    end

    emails = %w(gospelmemes@loverealm.org hearts@loverealm.org  christianweddings@easy.com breakingnews@loverealm.org fun@loverealm.org god@loverealm.org jesus@loverealm.org spirit@loverealm.org otabil@loverealm.org archbishop@loverealm.org dag@loverealm.org tdj@loverealm.org pope@loverealm.org)
    User.where(email: emails).each do |user|
      @user.following << user unless @user.following.include?(user)
    end

    if @user.phone_number.present?
      PhoneNumberInvitation.where(phone_number: @user.phone_number)
                           .find_each do |item|
        @user.following << item.user unless @user.following.include?(item.user)
      end
    end
  end
end
