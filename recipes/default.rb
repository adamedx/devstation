# Cookbook Name:: devstation
# Recipe:: default
#
# Copyright 2015, Adam Edwards
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/provisioning/azure_driver'

settings = RecipeSettings.new(node)

settings.validate_mandatory_setting!('user_secret')
settings.validate_mandatory_setting!('storage_account')

with_chef_server ConfigWithoutLocalMode.workstation_config[:chef_server_url],
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]

with_driver 'azure'

machine_name = settings.value_of('workstation_name', 'devstation')
additional_run_list = settings.value_of('run_list', '').split(',')

# These options configure a system with an admin user named
# 'localadmin' and use that to bootstrap the system.
# The user name *must* be localadmin -- seems to be an
# issue with chef-provisioning-azure.
azure_machine_options = {
  :bootstrap_options => {
    :vm_user => 'localadmin', # Why do I always have to use localadmin?
    :cloud_service_name => settings.value_of('cloud_service', machine_name),
    :storage_account_name => settings.value_of('storage_account'), #required
    :vm_size => settings.value_of('vm_size', 'Medium'), # required
    :location => settings.value_of('location', 'West US'), # required
    :tcp_endpoints => settings.value_of('tcp_endpoints', ''), # optional, e.g. '3389:3389'
    :winrm_transport => (settings.value_of('transport', :winrm) != :winrm) ? nil : { # optional
      'https' => { # required (valid values: 'http', 'https')
        :no_ssl_peer_verification => true # optional,(default: false),
      }
    }
  },
  :password => settings.value_of('user_secret'), # required
  :image_id => settings.value_of('image_id', 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201502.01-en.us-127GB.vhd') # required
}

machine machine_name do
  machine_options azure_machine_options
  recipe 'devbox'
  recipe 'myemacs'
  additional_run_list.each do | element |
    recipe element
  end
end


