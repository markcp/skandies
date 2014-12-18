module YearsHelper

  def results_display_year
    @results_display_year ||= Year.results_display
  end

  def results_display_year?(year)
    year == current_year
  end

  def active_voting_year
    @active_voting_year ||= Year.active_voting
  end

  def active_voting_year?(year)
    year == active_voting_year
  end

  def voting_display_year
    active_voting_year ? active_voting_year : results_display_year
  end
end
