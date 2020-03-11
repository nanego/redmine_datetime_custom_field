require "active_support/time_with_zone"

module ActiveSupport

  class TimeWithZone

    def cwday
      self.to_date.cwday
    end

  end

end
