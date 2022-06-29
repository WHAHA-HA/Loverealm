module Admin
  class HomeController < BaseController
    def index
      users_count = User.count
      @stats = {
        number_of_users: {
          total_count: users_count,
          male_share: percentage(User.where('sex = 0').count, users_count),
          female_share: percentage(User.where('sex = 1').count, users_count)
        },
        number_of_votes: Vote.count,
        number_of_comments: Comment.count,
        number_of_shares: Share.count,
        monthly_active_users: monthly_active_users,
        joined_last_month: User.where('created_at > ?', 1.month.ago).count,
        net_promoter_score: percentage(
          PhoneNumberInvitation.uniq.count(:user_id), users_count)
      }

      @top_contents = {
        most_liked_contents: Content.order('cached_votes_score DESC').limit(5),
        most_shared_contents: Content.order('shares_count DESC').limit(5),
        most_commented_contents: Content.order('comments_count DESC').limit(5)
      }
    end

    private

    def monthly_active_users
      [
        Comment.where('created_at > ?', 1.month.ago)
          .uniq.count(:user_id),
        Share.where('created_at > ?', 1.month.ago)
          .uniq.count(:user_id),
        Vote.where('created_at > ?', 1.month.ago)
          .uniq.count(:voter_id)
      ].max
    end

    def percentage value, total
      "#{'%.2f' % (value / total.to_f * 100)}%"
    end
  end
end
