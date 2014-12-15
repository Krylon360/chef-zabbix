class Chef
  module Zabbix
    module API
      module  Enumeration
        class << self
          def included(base)
            base.extend(ClassMethods)
            base.send(:include, ClassMethods)
          end

          def extended(base)
            base.send(:include, ClassMethods)
          end
        end

        module ClassMethods
          attr_reader :enumeration_values
          def enum(name, val)
            @enumeration_values ||= {}
            @enumeration_values[name] ||= new(val)
            # The better solution would be to just call define_singleton_method
            # but that doesn't work in 1.8.x and we want 1.8.x compatibility
            eigen_class = class << self; self; end
            eigen_class.send(:define_method, name) do
              @enumeration_values[name]
            end
          end
        end

        attr_reader :value
        def initialize(value)
          @value = value
        end
      end

      class ActionConditionType
        include Enumeration
        enum :host_group,                  0
        enum :host,                        1
        enum :trigger,                     2
        enum :trigger_name,                3
        enum :trigger_severity,            4
        enum :trigger_value,               5
        enum :time_period,                 6
        enum :host_ip,                     7
        enum :discovered_service_type,     8
        enum :discovered_service_port,     9
        enum :discovery_status,            10
        enum :uptime_or_downtime_duration, 11
        enum :received_value,              12
        enum :host_template,               13
        enum :application,                 15
        enum :maintenance_status,          16
        enum :node,                        17
        enum :discovery_rule,              18
        enum :discovery_check,             19
        enum :proxy,                       20
        enum :discovery_object,            21
        enum :host_name,                   22
        enum :event_type,                  23
        enum :host_metadata,               24
      end

      class ActionEvalType
        include Enumeration
        enum :and_or, 0
        enum :and,    1
        enum :or,     2
      end

      class ActionEventSource
        include Enumeration
        enum :trigger,           0
        enum :discovery,         1
        enum :auto_registration, 2
        enum :internal,          3
      end

      class ActionOperationType
        include Enumeration
        enum :send_message,           0
        enum :remote_command,         1
        enum :add_host,               2
        enum :remove_host,            3
        enum :add_to_host_group,      4
        enum :remove_from_host_group, 5
        enum :link_to_template,       6
        enum :unlink_from_template,   7
        enum :enable_host,            8
        enum :disable_host,           9
      end

      class ActionOperator
        include Enumeration
        enum :equals,           0
        enum :not_equals,       1
        enum :like,             2
        enum :not_like,         3
        enum :in,               4
        enum :equal_or_greater, 5
        enum :equal_or_lesser,  6
        enum :not_in,           7
      end

      class ActionRecoveryStatus
        include Enumeration
        enum :disabled, 0
        enum :enabled,  1
      end

      class ActionStatus
        include Enumeration
        enum :enabled,  0
        enum :disabled, 1
      end

      class AuthType
        include Enumeration
        enum :password,     0
        enum :private_key,  1
      end

      class DataType
        include Enumeration
        enum :decimal,      0
        enum :octal,        1
        enum :hexadecimal,  2
        enum :boolean,      3
      end

      class Delta
        include Enumeration
        enum :as_is,            0
        enum :speed_per_second, 1
        enum :simple_change,    2
      end

      class SNMPV3SecurityLevel
        include Enumeration
        enum :no_auth_no_priv,  0
        enum :auth_no_priv,     1
        enum :auth_priv,        2
      end

      class ItemType
        include Enumeration
        enum :zabbix_agent,               0
        enum :snmp_v1_agent,              1
        enum :zabbix_trapper,             2
        enum :simple_check,               3
        enum :snmp_v2_agent,              4
        enum :zabbix_internal,            5
        enum :snmp_v3_agent,              6
        enum :zabbix_agent_active_check,  7
        enum :zabbix_aggregate,           8
        enum :web_item,                   9
        enum :externali_check,            10
        enum :database_monitor,           11
        enum :ipmi_agent,                 12
        enum :ssh_agent,                  13
        enum :telnet_agent,               14
        enum :calculated,                 15
        enum :jmx_agent,                  16
        enum :snmp_trap,                  17
      end

      class ItemValueType
        include Enumeration
        enum :float, 0
        enum :character, 1
        enum :log, 2
        enum :unsigned, 3
        enum :text, 4
      end

      class TriggerPriority
        include Enumeration
        enum :not_classified, 0
        enum :information, 1
        enum :warning, 2
        enum :average, 3
        enum :high, 4
        enum :disaster, 5
      end

      class TriggerValue
        include Enumeration
        enum :ok, 0
        enum :problem, 1
      end

      class ItemStatus
        include Enumeration
        enum :enabled,        0
        enum :disabled,       1
        enum :not_supported,  2
      end

      class TriggerStatus
        include Enumeration
        enum :active, 0
        enum :disabled, 1
      end

      class TriggerType
        include Enumeration
        enum :normal, 0
        enum :multiple, 1
      end

      class GraphItemCalcFunction
        include Enumeration
        enum :min,      1
        enum :max,      2
        enum :average,  4
        enum :all,      7
      end

      class GraphItemType
        include Enumeration
        enum :simple,     0
        enum :aggregated, 1
        enum :graph,      2
      end

      class GraphType
        include Enumeration
        enum :normal, 0
        enum :stacked, 1
        enum :pie, 2
        enum :exploded, 3
      end

      class GraphAxisType
        include Enumeration
        enum :calculated, 0
        enum :fixed, 1
        # TODO: Update the graph provider to do an update after it has created
        # all of its item so that you can map an item id and support this value
        # enum :item, 2
      end

      class IPMIAuthType
        include Enumeration
        enum :default,   -1
        enum :none,       0
        enum :md2,        1
        enum :md5,        2
        enum :straight,   3
        enum :oem,        4
        enum :rmcp_plus,  5
      end

      class IPMIPrivilege
        include Enumeration
        enum :callback,   1
        enum :user,       2
        enum :operator,   3
        enum :admin,      4
        enum :oem,        5
      end

      class HostInterfaceType
        include Enumeration
        enum :agent,  1
        enum :snmp,   2
        enum :ipmi,   3
        enum :jmx,    4
      end

      class MediaType
        include Enumeration
        enum :email,       0
        enum :script,      1
        enum :SMS,         2
        enum :Jabber,      3
        enum :EZ_Texting,  100
      end

      class MediaTypeStatus
        include Enumeration
        enum :enabled,  0
        enum :disabled, 1
      end
    end
  end
end
