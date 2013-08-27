# -*- encoding: utf-8 -*-

module CalendarBuilder
  class CalendarDate
    attr_accessor :calendar, :date

    def initialize(calendar, date)
      @calendar = calendar
      @date     = date
    end

    def year
      date.year
    end

    def month
      date.month
    end

    def week
      date.strftime( calendar.week_start==1 ? '%W' : '%U' ).to_i
    end

    # 0 = Sunday, 6 = Saturday
    def weekend?
      [0, 6].include?(date.wday)
    end

    def day
      date.day
    end

    # Prev/Next
    def next_month
      self.month == 12 ? 1 : (self.month + 1)
    end

    def prev_month
      self.month == 1 ? 12 : (self.month - 1)
    end

    def prev_month?
      self.calendar_date.prev_month == self.month
    end

    def current_month?
      self.calendar_date.month == self.month
    end

    def next_month?
      self.calendar_date.next_month == self.month
    end

    def prev_week
      self.week == 1 ? 53 : (self.week - 1)
    end

    def next_week
      self.week == 53 ? 1 : (self.week + 1)
    end

    def prev_week?
      self.calendar_date.prev_week == self.week
    end

    def current_week?
      self.calendar_date.week == self.week
    end

    def next_week?
      self.calendar_date.next_week == self.week
    end

    def current?
      self.calendar_date.date == self.date
    end

    def today?
      self.date == Date.today
    end

    def calendar_date
      calendar.calendar_date
    end

  end
end
