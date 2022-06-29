namespace :data do
  desc 'Assigns additional followers'
  task assign_additional_followers: :environment do
    emails = %w(gospelmemes@loverealm.org hearts@loverealm.org  christianweddings@easy.com breakingnews@loverealm.org fun@loverealm.org god@loverealm.org jesus@loverealm.org spirit@loverealm.org otabil@loverealm.org archbishop@loverealm.org dag@loverealm.org tdj@loverealm.org pope@loverealm.org)
    following_users = User.where(email: emails).to_a
    User.where.not(email: emails).find_each do |user|
      p "Add follings to #{user.email}"
      following_users.each do |following_user|
        user.following << following_user unless user.following.include?(following_user)
      end
    end
  end
end
