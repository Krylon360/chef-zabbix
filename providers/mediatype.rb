action :create_or_update do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|

    params = {
      :description => new_resource.name
    }

    simple_value_keys = [
      :exec_path, :gsm_modem, :passwd,
      :smtp_email, :smtp_helo, :smtp_server, :username
    ]
    simple_value_keys.each do |key|
      params[key] = new_resource.send(key) if new_resource.send(key)
    end

    enum_value_keys = [
      :status, :type
    ]
    enum_value_keys.each do |key|
      params[key] = new_resource.send(key).value if new_resource.send(key)
    end

    verb = 'create'

    # Check to see if this mediatype already exists
    mediatype_ids = Chef::Zabbix::API.find_mediatype_ids(connection, new_resource.name)

    unless mediatype_ids.empty?
      params[:mediatypeid] = mediatype_ids.first['mediatypeid']
      verb = 'update'
    end

    method = "mediatype.#{verb}"
    connection.query(
      :method => method,
      :params => params
    )
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  Chef::Zabbix.with_connection(new_resource.server_connection) do |connection|
    mediatype_ids = Chef::Zabbix::API.find_mediatype_ids(connection, new_resource.name)
    if !mediatype_ids.empty?
      # This *shouldn't* return more then one mediatype_id, but just to be safe we'll just map the list
      params = mediatype_ids.map { |t| t['mediatypeid'] }
      connection.query(
        :method => 'mediatype.delete',
        :params => params
      )
    else
      # Nothing to update, move along
      Chef::Log.debug "mediatype:delete:Could not find a mediatype named #{new_resource.name}, nothing to delete"
    end

    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  run_context.include_recipe 'zabbix::_providers_common'
  require 'zabbixapi'
end
