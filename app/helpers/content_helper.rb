module ContentHelper
  def posted_time(content)
    mess = ''
    second_diff = Time.now - content.created_at
    min_diff = (second_diff / 60).to_i
    hours_diff = (min_diff / 60).to_i
    if min_diff < 1
      mess = 'Just now.'
    elsif  min_diff < 60
      mess = "#{pluralize min_diff, 'minute'} ago."
    elsif hours_diff < 24
      mess = "#{pluralize hours_diff, 'hour'} ago."
    else
      pretty_time content.created_at
    end
  end

  def content_owner(owner)
    link_to owner.full_name, dashboard_profile_path(owner)
  end

  def comments_count(content)
    content.comments.count
  end

  def render_content_item(content, **options)
    partial_name = content.content_type
    if options[:type].present?
      partial_name = "#{options[:type]}_#{partial_name}"
    end
    render partial: "dashboard/contents/#{partial_name}", locals: {
      content: content
    }
  end

  def sanitized_preview(content)
    tags = %w(h1 h2 h3 img b p strong em u a li br blockquote div)

    sanitize(content, tags: tags, attributes: %w(href id class style src data-id))
  end

  def pure_text(content)
    simple_format(content)
  end

  def embeded_youtube_video youtube_id
    content_tag :div, nil, class: 'youtube', data: { id: youtube_id, params: 'modestbranding=1&showinfo=0&rel=0' }
  end

  def inject_embeded_youtube_videos text
    match_data = text.scan(/(?<link>(https?:\/\/)?(www\.)?youtube.com\/watch\?(.*\&)?v=(?<id>[\d\w-]+))/)
    doc = Nokogiri::HTML::DocumentFragment.parse text
    if match_data.present?
      match_data.each do |(link, id)|
        element = doc.css("a[href=\"#{link}\"]").first
        element.replace(embeded_youtube_video(id)) if element.present?
      end
    end
    doc.to_s
  end

  def prepare_story_text text
    inject_embeded_youtube_videos(text)
  end
end
