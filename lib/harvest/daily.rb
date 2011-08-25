module Harvest
  class Daily < Hashie::Dash
    include Harvest::Model
    
    property :for_day
    property :day_entries
    property :projects
    
    skip_json_root true
    
    def initialize(args = {})
      args = args.stringify_keys
      self.for_day = args.delete("for_day") if args["for_day"]
      self.projects = args.delete("projects") if args["projects"]
      self.day_entries = args.delete("day_entries") if args["day_entries"]
      super
    end
    
    def for_day=(date)
      self["for_day"] = (String === date ? Time.parse(date) : date)
    end
    
    def projects=(projects)
      self["projects"] = Project.parse(projects)
    end
    
    def day_entries=(day_entries)
      self["day_entries"] = TimeEntry.parse(day_entries)
    end
    
    def as_json(args = {})
      super(args).stringify_keys.tap do |hash| 
        hash.update("for_day" => (for_day.nil? ? nil : for_day.to_time.xmlschema))
      end
    end
    
    class Project < Hashie::Dash
      include Harvest::Model
      
      skip_json_root true

      property :id
      property :name
      property :code
      property :client
      property :tasks
      
      def initialize(args = {})
        self.tasks = args.delete("tasks") if args["tasks"]
        super
      end
      
      def tasks=(tasks)
        self["tasks"] = Task.parse(tasks)
      end
    end
    
    class Task < Hashie::Dash
      include Harvest::Model
      
      skip_json_root true
      
      property :id
      property :name
      property :billable
      
      alias billable? billable
    end
  end
end