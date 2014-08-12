module Nuker

  class Project < ::ActiveRecord::Base
    has_one :root_folder, :class_name => "Nuker::Folder", :dependent => :destroy
    has_many :project_users, :class_name => "Nuker::ProjectUser", :dependent => :destroy
    has_many :users, :through => :project_users, :extend => Nuker::ProjectUsers
    has_many :folders, :class_name => "Nuker::Folder", :dependent => :destroy
    has_many :features, :class_name => "Nuker::Feature", :extend => Nuker::ProjectFeatures
    has_many :tags, :class_name => "Nuker::Tag", :dependent => :destroy

    validates_presence_of :name
    validates_length_of :name, :maximum => 256
    validates_uniqueness_of :name

    after_create { |project| Nuker::Folder.create_root_folder!(project) }

    def self.default
      raise "No default project could be identified as more than one project exists" if count > 1
      first ||  create!(:name => "Auto-generated project")
    end

    def steps
      @steps ||= Nuker::ProjectSteps.new(self)
    end

    def description_lines
      @description_lines ||= Nuker::ProjectFeatureDescriptionLines.new(self)
    end
  end
end
