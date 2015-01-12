module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "raocow"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns page execution time string for BaseController controllers
  def execution_time_string(start_time)
    execution_time = 1000.0 * (Time.now - start_time)
    "Execution time: #{'%.3f' % execution_time}ms"
  end
end
