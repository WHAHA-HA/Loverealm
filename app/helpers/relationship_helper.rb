module RelationshipHelper
  def relationship_counter user, relationship_type
    if relationship_type == :followers
      number_to_human(user.num_of_followers, :format => '%n%u', :units => { :thousand => 'K' })
    else
      user.send(relationship_type).count
    end
  end
end
