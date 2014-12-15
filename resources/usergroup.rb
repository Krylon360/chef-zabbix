actions :create_or_update, :delete
default_action :create_or_update

attribute :name, :kind_of => String, :name_attribute => true, :required => true
# This accepts an Array of Strings as the names of the hostgroups to deny access to
attribute :deny, :kind_of => Array, :default => []
# This accepts an Array of Strings as the names of the hostgroups to grant read_only access to
attribute :read_only, :kind_of => Array, :default => []
# This accepts an Array of Strings as the names of the hostgroups to grant read_write access to
attribute :read_write, :kind_of => Array, :default => []

attribute :server_connection, :kind_of => Hash, :default => {}
