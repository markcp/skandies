class Results::YearsController < ApplicationController
  def index
    @year = Year.current
    @years = Year.all_but_current
  end
end
