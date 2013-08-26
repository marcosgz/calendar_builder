module CalendarBuilder
  module ViewHelpers
    def render_calendar_table(*args, &block)
      CalendarBuilder.render_table(*args, &block).html_safe
    end
  end
end
