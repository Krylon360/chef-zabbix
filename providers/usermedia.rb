action :create_or_update do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|

    params = {}

    # Find the userid and mediatypeid
    users = Chef::Zabbix::API.find_user_ids(connection, new_resource.user)
    Chef::Log.info "usermedia: find_user_ids returned: #{users}"
    Chef::Log.fatal "usermedia: Unable to find user #{new_resource.user}" unless users.first
    userid = users.first['userid']
    mediatypes = Chef::Zabbix::API.find_mediatype_ids(connection, new_resource.mediatype)
    Chef::Log.info "usermedia: find_mediatype_ids returned: #{mediatypes}"
    Chef::Log.fatal "usermedia: Unable to find mediatype #{new_resource.mediatype}" unless mediatypes.first
    mediatypeid = mediatypes.first['mediatypeid']

    params[:users] = [{ :userid => userid }]
    params[:medias] = {}
    params[:medias][:mediatypeid] = mediatypeid
    params[:medias][:sendto] = new_resource.sendto if new_resource.sendto
    params[:medias][:severity] = new_resource.severity
    params[:medias][:period] = new_resource.period
    params[:medias][:active] = 0

    connection.query(
      :method => 'user.addmedia',
      :params => params
    )
  end
  new_resource.updated_by_last_action(true)
end

# FIXME: Add delete action for usermedia
# action :delete do
#   Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|
#     usergroup_ids = Chef::Zabbix::API.find_usergroup_ids(connection, new_resource.name)
#     if !usergroup_ids.empty?
#       # This *shouldn't* return more then one usergroup_id, but just to be safe we'll just map the list
#       params = usergroup_ids.map { |t| t['usergroupid'] }
#       connection.query(
#         :method => 'usergroup.delete',
#         :params => params
#       )
#     else
#       # Nothing to update, move along
#       Chef::Log.debug "usergroup:delete:Could not find a usergroup named #{new_resource.name}, nothing to delete"
#     end

#     new_resource.updated_by_last_action(true)
#   end
# end

def load_current_resource
  run_context.include_recipe 'zabbix::_providers_common'
  require 'zabbixapi'
end
