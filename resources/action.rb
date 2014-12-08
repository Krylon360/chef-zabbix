actions :create_or_update, :delete
default_action :create_or_update

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :status, :kind_of => Chef::Zabbix::API::ActionStatus, :default => Chef::Zabbix::API::ActionStatus.enabled
attribute :alert_subject, :kind_of => String
attribute :alert_message, :kind_of => String
attribute :alert_message_file, :kind_of => String
attribute :recovery_message_status, :kind_of => Chef::Zabbix::API::ActionRecoveryStatus
attribute :recovery_subject, :kind_of => String
attribute :recovery_message, :kind_of => String
attribute :recovery_message_file, :kind_of => String
attribute :esc_period, :kind_of => Integer, :required => true
attribute :eventsource, :kind_of => Chef::Zabbix::API::ActionEventSource, :required => true
attribute :evaltype, :kind_of => Chef::Zabbix::API::ActionEvalType, :default => Chef::Zabbix::API::ActionEvalType.and_or
# This accepts an Array of Condition hash objects, which are defined to match the zabbix API condition format
# e.g.
# [{ :conditiontype => Chef::Zabbix::API::ActionConditionType.maintenance_status.value,
#   :operator => Chef::Zabbix::API::ActionOperator.not_in.value },
# { :conditiontype => Chef::Zabbix::API::ActionConditionType.trigger_value.value,
#   :operator => Chef::Zabbix::API::ActionOperator.equals.value,
#   :value => Chef::Zabbix::API::TriggerValue.problem.value }]
attribute :conditions, :kind_of => Array
# This accepts an Array of Operation hash objects, which are defined to match the zabbix API operation format,
# except that instead of using group IDs you can use the group name and we'll look it up on the fly for insertion
# e.g.
# [{ :operationtype => Chef::Zabbix::API::ActionOperationType.send_message.value,
#    :opmessage_grp => 'user-group-name' }]
attribute :operations, :kind_of => Array

attribute :server_connection, :kind_of => Hash, :default => {}
