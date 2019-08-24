class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.inheritance_column = nil

  def error_msgs
    self.errors.messages.collect { |k, v| { k.to_s => v.last } }
  end
end
