module ApplicationHelper
  def shortik(s, max_len)
    s = strip_tags(s)
    b = s.split(' ').each_with_object('') { |x, ob| break ob unless ob.length + ' '.length + x.length <= max_len; ob << (' ' + x) }.strip unless s.nil?
  end

  def pretty_time(date)
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.min}"
  end

  def hide_login
    params[:controller] == 'home' && params[:action] != 'index'
  end

  def page_owner?(user)
    current_user == user
  end

  def track_conversion?
    params[:track_conversion].present?
  end

  def show_splash_screen?
    browser.platform.android? && browser.device.mobile? && cookies['splash-screen'] != 'hidden'
  end

  def tv(key, options = {})
    t key, options.merge(scope: 'views')
  end
end
