action :create_or_update do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|

    params = {}

    simple_value_keys = [
      :name, :esc_period
    ]
    simple_value_keys.each do |key|
      params[key] = new_resource.send(key) if new_resource.send(key)
    end

    enum_value_keys = [
      :evaltype, :status, :eventsource
    ]
    enum_value_keys.each do |key|
      params[key] = new_resource.send(key).value if new_resource.send(key)
    end

    params[:def_shortdata] = new_resource.alert_subject if new_resource.alert_subject
    if new_resource.alert_message
      params[:def_longdata] = new_resource.alert_message
    elsif new_resource.alert_message_file
      params[:def_longdata] = IO::read(new_resource.alert_message_file)
    end

    params[:recovery_msg] = new_resource.recovery_message_status.value if new_resource.recovery_message_status
    params[:r_shortdata] = new_resource.recovery_subject if new_resource.recovery_subject
    if new_resource.recovery_message
      params[:r_longdata] = new_resource.recovery_message
    elsif new_resource.recovery_message_file
      params[:r_longdata] = IO::read(new_resource.recovery_message_file)
    end
    params[:conditions] = new_resource.conditions if new_resource.conditions

    if new_resource.operations
      # Operations may contain user group references by name, so we loop over them to replace with the group ID
      params[:operations] = new_resource.operations
      params[:operations].each do |op|
        if op[:opmessage_groups]
          op[:opmessage_grp] = []
          op[:opmessage_groups].each do |usergroupname|
          usergroup_ids = Chef::Zabbix::API.find_usergroup_ids(connection, usergroupname)

          if usergroup_ids.empty?
            Chef::Log.fatal "action:create_or_update: Operation contained reference to non-existant user group '#{usergroupname}'"
          end

          op[:opmessage_grp] << { :usrgrpid => usergroup_ids.first['usrgrpid']}
          end
          op.delete(:opmessage_groups)
        end
      end
    end

    verb = 'create'

    # Check to see if this action already exists
    action_ids = Chef::Zabbix::API.find_action_ids(connection, new_resource.name)

    unless action_ids.empty?
      verb = 'update'
      params[:actionid] = action_ids.first['actionid']
      params.delete(:eventsource)  # Read-only field on existing actions
    end

    method = "action.#{verb}"
    connection.query(
      :method => method,
      :params => params
    )
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|
    action_ids = Chef::Zabbix::API.find_action_ids(connection, new_resource.name)
    if !action_ids.empty?
      # This *shouldn't* return more then one action_id, but just to be safe we'll just map the list
      params = action_ids.map { |t| t['actionid'] }
      connection.query(
        :method => 'action.delete',
        :params => params
      )
    else
      # Nothing to update, move along
      Chef::Log.debug "action:delete:Could not find a action named #{new_resource.name}, nothing to delete"
    end

    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  run_context.include_recipe 'zabbix::_providers_common'
  require 'zabbixapi'
end
