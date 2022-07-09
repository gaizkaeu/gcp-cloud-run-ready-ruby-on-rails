class Navigation::Component < ViewComponent::Base
  renders_many :nav_links, 'NavigationLink'

  class NavigationLink < ViewComponent::Base
    attr_reader :name, :href

    def initialize(name:, href:)
      @name = name
      @href = href
      super
    end
  end
end
