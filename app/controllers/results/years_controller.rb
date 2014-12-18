class Results::YearsController < ApplicationController
  def index
    @year = Year.results_display
    @years = Year.all_but_results_display
  end
end
