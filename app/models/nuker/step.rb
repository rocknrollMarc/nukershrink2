module Nuker
  
  class Step < ::ActiveRecord::Base
    include Nuker::BelongsToTable
    include Nuker::FeatureSummaryChangeObserver
    include Nuker::Cucumber::Ast::Adapter::StepAdapter
    include Nuker::Cucumber::Formatter::StepFormatter

    set_table_adapter Nuker::Table

    belongs_to :scenario, :class_name => "Nuker::Scenario"
    acts_as_list :scope => :scenario

    validates_presence_of :text, :if => :text_type?
    validates_length_of :text, :maximum => 256, :if => :text_type?

    alias_attribute :calculate_summary, :text

    TYPE_TEXT = "text".freeze
    TYPE_TABLE = "table".freeze

    def step_type
      table ? TYPE_TABLE : TYPE_TEXT
    end

    def text_type?
      table.nil?
    end

    def feature
      scenario.feature
    end

    def folder
      scenario.folder
    end

    def calculate_summary
      text_type? ? text : table.calculate_summary
    end



  end
end
