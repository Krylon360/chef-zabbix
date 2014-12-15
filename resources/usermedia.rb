actions :create_or_update # , :delete
default_action :create_or_update

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :user, :kind_of => String, :required => true
attribute :mediatype, :kind_of => String, :required => true
attribute :sendto, :kind_of => String
attribute :period, :kind_of => String, :default => '1-7,00:00-24:00'

# Create bit mask for all severities
# Each severity type value is used as the bitmask location for the bit
# to enable alerts of that severity
attribute :severity, :kind_of => Integer, :default =>  ((1 << Chef::Zabbix::API::TriggerPriority.not_classified.value) | (1 << Chef::Zabbix::API::TriggerPriority.information.value) | (1 << Chef::Zabbix::API::TriggerPriority.warning.value) | (1 << Chef::Zabbix::API::TriggerPriority.average.value) | (1 << Chef::Zabbix::API::TriggerPriority.high.value) | (1 << Chef::Zabbix::API::TriggerPriority.disaster.value))

attribute :server_connection, :kind_of => Hash, :default => {}
