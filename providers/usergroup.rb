action :create_or_update do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|

    params = {
      :name => new_resource.name
    }

    # Create an array of hostgroups to grant/deny access to
    rights = []

    # Build a hash of hostgroup name to groupid
    hglist = Chef::Zabbix::API.get_hostgroups(connection, {})

    hostgroups = Hash.new
    hglist.each do |h|
      hostgroups[h['name']] = h['groupid']
    end

    new_resource.deny.each do |hg|
      if hostgroups[hg].nil?
        Chef::Log.info "usergroup:create_or_update:No hostgroup #{hg} found"
        next
      end
      rights << { :permission => 0, :id => hostgroups[hg] }
    end

    new_resource.read_only.each do |hg|
      if hostgroups[hg].nil?
        Chef::Log.info "usergroup:create_or_update:No hostgroup #{hg} found"
        next
      end
      rights << { :permission => 2, :id => hostgroups[hg] }
    end

    new_resource.read_write.each do |hg|
      if hostgroups[hg].nil?
        Chef::Log.info "usergroup:create_or_update:No hostgroup #{hg} found"
        next
      end
      rights << { :permission => 3, :id => hostgroups[hg] }
    end

    params[:rights] = rights

    verb = 'create'

    # Check to see if this usergroup already exists
    usergroup_ids = Chef::Zabbix::API.find_usergroup_ids(connection, new_resource.name)

    unless usergroup_ids.empty?
      params[:usrgrpid] = usergroup_ids.first['usrgrpid']
      verb = 'update'
    end

    method = "usergroup.#{verb}"
    connection.query(
      :method => method,
      :params => params
    )
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|
    usergroup_ids = Chef::Zabbix::API.find_usergroup_ids(connection, new_resource.name)
    if !usergroup_ids.empty?
      # This *shouldn't* return more then one usergroup_id, but just to be safe we'll just map the list
      params = usergroup_ids.map { |t| t['usrgrpid'] }
      connection.query(
        :method => 'usergroup.delete',
        :params => params
      )
    else
      # Nothing to update, move along
      Chef::Log.debug "usergroup:delete:Could not find a usergroup named #{new_resource.name}, nothing to delete"
    end

    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  run_context.include_recipe 'zabbix::_providers_common'
  require 'zabbixapi'
end
