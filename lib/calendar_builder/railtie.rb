require 'calendar_builder/view_helpers'
module CalendarBuilder
  class Railtie < Rails::Railtie
    initializer "calendar_builder.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
