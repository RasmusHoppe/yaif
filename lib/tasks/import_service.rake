require 'yaml'

namespace :service do
  desc "Import service information into database"
  services = FileList["service/*.yaml"]
  task :import => :environment do
    services.each do |s|
      puts "Loading #{s}..."
      y = YAML::load_file(s.to_s)
      y.symbolize_keys!

      y[:service].symbolize_keys!
      puts "\tImport Service: #{y[:service][:name]}..."
      y[:service][:auth_data].symbolize_keys! rescue nil
      unless service = Service.find_by_name(y[:service][:name])
        service = Service.create! y[:service]
      else
        service.update_attributes y[:service]
      end

      y[:trigger].each do |t|
        t.symbolize_keys!
        puts "\tImport Trigger: #{t[:name]}..."
        t[:service] = service
        unless trigger = service.triggers.find_by_name(t[:name])
          Trigger.create! t
        else
          trigger.update_attributes t
        end
      end rescue nil

      y[:action].each do |a|
        a.symbolize_keys!
        puts "\tImport Action: #{a[:name]}..."
        a[:service] = service
        unless action = service.actions.find_by_name(a[:name])
          Action.create! a
        else
          action.update_attributes a
        end
      end rescue nil
    end
  end
end
