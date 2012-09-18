class CreateReminderProjects < ActiveRecord::Migration
  def self.up
    create_table :reminder_projects do |t|
      t.column :reminder_configuration_id, :integer
      t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :reminder_projects
  end
end
