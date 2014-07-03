require 'csv' # adds a .to_csv method to Array instances

class Array 
  alias old_to_csv to_csv #keep reference to original to_csv method

  def to_csv(options = Hash.new)
    # override only if first element actually has as_csv method
    return old_to_csv(options) unless self.first.respond_to? :as_csv
    # use keys from first row as header columns
    keys = first.as_csv.keys
    out = keys.to_csv(options)
    self.each do |r|
      values = Array.new
      keys.each do |key|
        values << r.as_csv[key]
      end
      out << values.to_csv(options)
    end
    out.encode(Encoding::SJIS)
  end
end

ActionController::Renderers.add :csv do |csv, options|
  csv = csv.respond_to?(:to_csv) ? csv.to_csv() : csv
  self.content_type ||= Mime::CSV
  self.response_body = csv
end
