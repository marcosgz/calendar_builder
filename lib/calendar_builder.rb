# -*- encoding: utf-8 -*-
require 'rubygems'
require 'date'

require "calendar_builder/version"
require "calendar_builder/calendar"
require "calendar_builder/calendar_date"

require 'calendar_builder/railtie' if defined?(Rails::Railtie)

module CalendarBuilder
  def self.build(*args, &block)
    calendar = Calendar.new(*args)
    block.arity < 1 ? calendar.instance_eval(&block) : block.call(calendar) if block_given?
    return calendar
  end


  def self.render_table(*args, &block)
    options  = args.last.is_a?(::Hash) ? args.pop : {}

    [].tap do |html|
      html << "<table class=\"#{ [options[:table_class] || 'calendar'].flatten.compact.join(' ') }\">"

      Calendar.new(*args) do |calendar|
        # Setup weekstart
        calendar.week_start = options[:week_start] if options.has_key?(:week_start)
        # Table Header
        html << '<thead>'
        unless options[:hide_month_names]
          html << '<tr class="month_names">'
          html << "<th class=\"previous #{ Date::MONTHNAMES[calendar.calendar_date.prev_month].to_s.downcase }\" colspan=\"2\">#{ options[:previous_month] }</th>"
          html << "<th class=\"current #{ Date::MONTHNAMES[calendar.calendar_date.month].to_s.downcase }\" colspan=\"3\">#{ Date::MONTHNAMES[calendar.calendar_date.month] }</th>"
          html << "<th class=\"next #{ Date::MONTHNAMES[calendar.calendar_date.next_month].to_s.downcase }\" colspan=\"2\">#{ options[:next_month] }</th>"
          html << '</tr>'
        end
        unless options[:hide_weekday_names]
          html << '<tr class="weekday_names">'
          calendar.weekday_names("%a").each do |key, value|
            html << "<th class=\"#{ key.downcase }\" scope=\"col\"><abbr title=\"#{ key }\">#{value}</abbr></th>"
          end
          html << '</tr>'
        end
        html << '</thead>'
        # Table Body
        html << "<tbody>"
        arr = calendar.dates
        # calendar.dates.in_groups_of(7, false)
        (0..arr.size/7 - 1).collect{|i| arr[i*7, 7]}.each do |dates|
          tr_classes = ['week']
          dates.each do |d|
            tr_classes << 'current_week' if d.week == calendar.calendar_date.week
          end
          html << "<tr class=\"#{tr_classes.uniq.join(' ')}\">"
          dates.each do |d|
            td_classes = ['day']
            td_classes << 'prev_month'  if d.prev_month?
            td_classes << 'next_month'  if d.next_month?
            td_classes << 'otherMonth'  if d.prev_month? || d.next_month?
            td_classes << 'weekend'     if d.weekend?
            td_classes << 'current'     if d.current?
            td_classes << 'today'       if d.today?
            html << "<td class=\"#{td_classes.join(' ')}\">"
            html << (block_given? ? block.call(d) : "<span>#{d.day}</span>")
            html << "</td>"
          end
          html << "</tr>"
        end
        html << "</tbody>"
      end
      html << "</table>"
    end.join("\n")

  end
end
