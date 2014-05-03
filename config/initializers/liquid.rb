#require File.join(Rails.root, 'lib', 'liquid', 'clot', 'no_model_form_tags.rb')
#require File.join(Rails.root, 'lib', 'liquid', 'clot', 'model_form_tags.rb')
#Dir[File.join(Rails.root, 'lib', 'liquid', 'clot', '*.rb')].each { |lib| puts lib; require lib }
%w{. tags drops filters}.each do |dir|
  Dir[File.join(Rails.root, 'lib', 'liquid', dir, '*.rb')].each { |lib| puts lib; require lib }
end
