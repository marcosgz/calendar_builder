require 'spec_helper'

describe CalendarBuilder::Calendar do
  describe :week_start do
    let(:model) { CalendarBuilder::Calendar.new(Date.today.year, Date.today.mon)}
    context "integer" do
      [0, 1].each do |val|
        it "allows '#{val}'" do
          model.week_start = val
          expect(model.week_start).to eq(val)
        end
      end

      (2..6).each do |val|
        it "defaults 0 with '#{val}'" do
          model.week_start = val
          expect(model.week_start).to eq(0)
        end
      end

      it "defaults 0 with invalid values" do
        model.week_start = 7
        expect(model.week_start).to eq(0)
      end
    end

    context "string" do
      Date::DAYNAMES[0..1].map(&:downcase).each_with_index do |val, num|
        it "allows '#{val}'" do
          model.week_start = val
          expect(model.week_start).to eq(num)
        end
      end

      Date::DAYNAMES[2..-1].map(&:downcase).each_with_index do |val, num|
        it "defaults 0 with '#{val}'" do
          model.week_start = val
          expect(model.week_start).to eq(0)
        end
      end

      it "defaults 0 with invalid values" do
        model.week_start = 'Foo'
        expect(model.week_start).to eq(0)
      end
    end
  end


  describe :date do
    context "without args" do
      subject { CalendarBuilder::Calendar.new.date }
      it { should eq(Date.new)}
    end

    context "only year" do
      subject { CalendarBuilder::Calendar.new(2013).date }
      it { should eq(Date.new(2013))}
    end

    context "year and month" do
      subject { CalendarBuilder::Calendar.new(2013, 1).date }
      it { should eq(Date.new(2013, 1))}
    end

    context "year, month and day" do
      subject { CalendarBuilder::Calendar.new(2013, 1, 31).date }
      it { should eq(Date.new(2013, 1, 31))}
    end

    context "String arguments" do
      subject { CalendarBuilder::Calendar.new("2013", "1", "31").date }
      it { should eq(Date.new(2013, 1, 31))}
    end
  end


  describe :first_date do
    let(:model) { CalendarBuilder::Calendar.new(2013, 8, 26) }

    context ":sunday week_start" do
      before(:each) do
        model.week_start = 'Sunday'
      end
      it { expect(model.first_date).to eq(Date.new(2013, 7, 28)) }
    end

    context ":monday week_start" do
      before(:each) do
        model.week_start = 'Monday'
      end
      it { expect(model.first_date).to eq(Date.new(2013, 7, 29)) }
    end
  end


  describe :last_date do
    describe "July 2013" do
      let(:model) { CalendarBuilder::Calendar.new(2013, 7, 10) }

      context ":sunday week_start" do
        before(:each) do
          model.week_start = 'Sunday'
        end
        it { expect(model.last_date).to eq(Date.new(2013, 8, 3)) }
      end

      context ":monday week_start" do
        before(:each) do
          model.week_start = 'Monday'
        end
        it { expect(model.last_date).to eq(Date.new(2013, 8, 4)) }
      end
    end

    describe "August 2013" do
      let(:model) { CalendarBuilder::Calendar.new(2013, 8, 10) }

      context ":sunday week_start" do
        before(:each) do
          model.week_start = 'Sunday'
        end
        it { expect(model.last_date).to eq(Date.new(2013, 8, 31)) }
      end

      context ":monday week_start" do
        before(:each) do
          model.week_start = 'Monday'
        end
        it { expect(model.last_date).to eq(Date.new(2013, 9, 1)) }
      end

    end
  end


  describe :all_dates do
    before(:each) do
      @model = CalendarBuilder::Calendar.new(2013, 8)
      @model.instance_variable_set(:@first_date, @first_date=Date.new(2013,8,1))
      @model.instance_variable_set(:@last_date, @last_date=Date.new(2013,8,10))
    end
    subject { @model.all_dates}
    it { should eq((@first_date..@last_date).to_a)}
  end

  pending :dates

  pending :weekday_names
end
