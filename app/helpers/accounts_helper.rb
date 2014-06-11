module AccountsHelper
  def award_option(work, item)
    if work.award_ids.include?(item._id.to_s)
      checked = true
    else
      checked = false
    end
    prizetext = item.prize ? content_tag(:span, number_to_jpy(item.prize.to_i) + '円', class:"prize") : ""
    subprizetext = item.supplementary_prize ? content_tag(:span, '副賞あり', class:"supplementary_prize") : ""
    title = content_tag(:a, item.title, href: "/awards/#{item._slug}", target:"_blank", for: item._id, class: 'award_link', title: strip_tags(item.description)) + prizetext +  subprizetext
    value = item._id
    return title, value, checked
  end


  def number_to_jpy(number)
    if (number > 10000)
      (number / 10000).floor.to_s + '万' + number_to_jpy(number % 10000)
    elsif (number > 1000)
      (number / 1000).floor.to_s + '千' + (number % 1000)
        else
      number == 0 ? "" : number.to_s
    end
  end
end

