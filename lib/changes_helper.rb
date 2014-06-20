module ChangesHelper
  DEFAULT_DATE_FORMAT = "%B %-d, %Y".freeze
  USERNAMES_TO_NAMES  = {
    "simplebits"  => "Dan Cederholm",
    "frogandcode" => "Rich Thornett",
    "tristandunn" => "Tristan Dunn",
    "pbyrne"      => "Patrick Byrne"
  }.freeze

  def changes
    changes = @items.select { |item| item[:kind] == "change" }
    changes.sort do |x, y|
      attribute_to_time(y[:created_at]) <=> attribute_to_time(x[:created_at])
    end
  end

  def name_for(username)
    USERNAMES_TO_NAMES[username]
  end

  def change_date(item)
    time = attribute_to_time(item[:created_at])
    time.strftime(DEFAULT_DATE_FORMAT)
  end
end
