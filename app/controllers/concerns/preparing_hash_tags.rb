module PreparingHashTags

  def prepare_hash_tags_for_story
    @list_of_tags = []
    params[:tags].split(',').each do |tag_name|
      tag = HashTag.find_by_name(tag_name)
      @list_of_tags << tag if tag.present?
    end
    @list_of_tags
  end
end
