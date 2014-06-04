class Dl
  include Mongoid::Document
  include Mongoid::Timestamps
  field :userid, type: String
  field :email, type: String
  field :material, type: String
  field :url, type: String

  attr :material_object
  
  def set_material_object(material_content)
    @material_object = material_content.entries.where("_slug.ja" => self.material).first
  end

  def user
    return User.where(_id: self.userid).first
  end
  
end
