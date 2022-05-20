class CreateReminderProjects < ActiveRecord::Migration[5.1]
  def self.up
    create_table :reminder_projects do |t|
      t.column :reminder_configuration_id, :integer
      t.column :project_id, :integer
    end unless table_exists? :reminder_projects
  end

  def self.down
    drop_table :reminder_projects if table_exists? :reminder_projects
  end
end
