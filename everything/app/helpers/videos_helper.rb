module VideosHelper

  def replace_linebreaks_br(string)

    string.gsub("\n", '<br>').html_safe

  end

end
