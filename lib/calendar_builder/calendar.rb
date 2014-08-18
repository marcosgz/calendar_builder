# -*- encoding: utf-8 -*-
module CalendarBuilder
  class Calendar
    attr_reader :date

    def initialize(*args, &block)
      @date = Date.new(*args.map(&:to_i).reject{|x| x.zero? })
      block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
      self
    end


    # :sunday, :monday
    def week_start=(val='Sunday')
      @last_date = @first_date = @calendar_date = nil
      @week_start = \
        case val.class.name
        when 'String', 'Symbol'
          Date::DAYNAMES[0,2].each_with_index.select do |day_name, index|
            day_name =~ /^#{val.to_s}$/i
          end.map{|d, i| i }.first
        when 'Fixnum'
          val if [0, 1].include?(val)
        end || 0
    end

    def week_start
      @week_start || 0
    end


    def week_end
      week_start > 0 ? week_start - 1 : 6
    end


    def calendar_date
      @calendar_date ||= CalendarDate.new(self, self.date)
    end

    def first_date
      @first_date ||= begin
        y = self.date.year
        m = self.date.month
        d = (1..31).detect{|x| Date.valid_date?(y, m, x)}
        fd = Date.new(y, m, d)
        fd -= (fd.jd - self.week_start+1) % 7
        fd
      end
    end


    def last_date
      @last_date ||= begin
        y = self.date.year
        m = self.date.month
        d = (1..31).to_a.reverse.detect{|x| Date.valid_date?(y, m, x)}
        ld = Date.new(y, m, d)
        ld.wday == week_end ? ld : ((ld+1)..(ld+7)).find{|d| d.wday == week_end}
      end
    end


    def all_dates
      (first_date..last_date).to_a
    end


    def dates(&block)
      self.all_dates.map do |date|
        obj = CalendarDate.new(self, date)
        block.arity < 1 ? obj.instance_eval(&block) : block.call(obj) if block_given?
        obj
      end
    end


    # %a - The abbreviated weekday name ("Sun")
    # %A - The full weekday name ("Sunday")
    def weekday_names(str='%a')
      all_dates[0, 7].inject({}) do |r, x|
        r.merge Hash[x.strftime('%A'), x.strftime(str.to_s)]
      end
    end
  end

end
