module Clot
  module FormFilters
    include ActionView::Helpers::FormHelper
    def label(input, field)
      field
    end
    def drop_class_to_table_item(clazz)
      match = /_drops/.match clazz.name.tableize
      match.pre_match
    end
   end
end
