require_dependency 'version'

class Version

  def behind_schedule?
    if completed_percent == 100
      return false
    elsif due_date && start_date
      done_date = start_date.to_date + ((due_date.to_date - start_date.to_date + 1)* completed_percent/100).floor
      return done_date <= User.current.today
    else
      false # No issues so it's not late
    end
  end

end
