class Champion < ActiveRecord::Base
  def name
    self[:name] || self[:code]
  end
end
