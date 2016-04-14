require 'date'
# this class takes into consideration that every input is
# submitted between the work hours
class DueDateCalculator
    def initialize
    @day
    @hour
    @month
    @year
  end
  # CalculateDueDate method takes the submit date and turnaround time as an
  # input and returns the date and time when the issue is to be resolved.
  def calculate_due_date(submitDate, turnaround)
    #initializing variables
    @day = submitDate.day + (turnaround/8)
    @hour = submitDate.hour + (turnaround%8)
    @month = submitDate.month
    @year = submitDate.year

    #checking values
    checkWeekendHours(submitDate, turnaround)
    checkYear
    checkHour
    checkWeekend
    checkMonth

    # the output
    date = Time.new(@year, @month, @day, @hour, submitDate.min, submitDate.sec)
    puts date.strftime("%A, %d/%m/%y %r")
    return date
  end

  def checkHour
    #if time is later than 5pm
    if @hour >= 17
      # starts the next day
      @day += 1
      @hour -= 8
    end
  end

  def checkWeekendHours(submitDate, turnaround)
    # to ignore weekends as work hours
    daysToWork = (turnaround / 8)
    daysToWeekend = (6 - submitDate.wday)
    workDays = 0
    if daysToWork > daysToWeekend
      daysToWork -= daysToWeekend
      begin
      @day += 2
      workDays += 5
      end while daysToWork > workDays
    end
  end

  def checkWeekend
    # if the deliver date points at a weekend, it jumps to next monday
    date = Time.new(@year, @month, @day)
    if date.saturday?
      @day += 2
    elsif date.sunday?
      @day += 1
    end
  end

  def checkMonth
    # we need this method because deliver date can be in the next month
    lastday= Date.new(@year, @month, -1)
    if lastday.day < @day
      return @month += 1, (@day -= lastday.day)
    end
  end

  def checkYear
    # in case today is the last day of the year (no holidays)
    lastday = Date.new(@year, @month, -1)
    if @month == 12 && lastday.day < @day
      return @year += 1, @month = 1, (@day -= lastday.day)
    end
  end
end

objclass = DueDateCalculator.new
date = DateTime.new(2015, 12, 11, 16)
#puts date.strftime("%A, %d/%m/%y %r")
objclass.calculate_due_date(date, 83)
