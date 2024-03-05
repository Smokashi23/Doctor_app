class RenameRoleNameToNameInRoles < ActiveRecord::Migration[7.1]
  def change
    rename_column :roles, :role_name, :name
  end
end
