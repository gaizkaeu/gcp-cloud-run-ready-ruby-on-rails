class FlashAlert::Component < ViewComponent::Base
  attr_reader :turbo_enabled

  def initialize(turbo_enabled: true)
    @turbo_enabled = turbo_enabled
    super
  end
  
end
