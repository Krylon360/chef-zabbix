actions :create_or_update, :delete
default_action :create_or_update

attribute :exec_path, :kind_of => String
attribute :gsm_modem, :kind_of => String
attribute :passwd, :kind_of => String
attribute :smtp_email, :kind_of => String
attribute :smtp_helo, :kind_of => String
attribute :smtp_server, :kind_of => String
attribute :username, :kind_of => String
attribute :status, :kind_of => Zabbix::API::MediaTypeStatus, :default => Zabbix::API::MediaTypeStatus.enabled
attribute :type, :kind_of => Zabbix::API::MediaType, :required => true

attribute :server_connection, :kind_of => Hash, :default => {}
