module UserHelper
  AVATAR_SIZES = { small: '150x150', thumb: '30x30' }.freeze

  def show_avatar(user, size, options = {})
    # TODO: show default/guest user image
    image_tag(user.avatar.url(size.to_sym), options) if user
  end

  def followers_count user
    number_to_human(user.num_of_followers, :format => '%n%u', :units => { :thousand => 'K' })
  end
end
