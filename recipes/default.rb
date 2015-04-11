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

RecipeSettings.validate_mandatory_setting!(node, 'user_secret','DEVSTATION_USER_SECRET')
RecipeSettings.validate_mandatory_setting!(node, 'storage_account','DEVSTATION_STORAGE_ACCOUNT')

with_driver 'azure'

with_chef_server "https://api.opscode.com/organizations/opscodeeasteng",
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]

# These options configure a system with an admin user named
# 'localadmin' and use that to bootstrap the system.
# The user name *must* be localadmin -- seems to be an
# issue with chef-provisioning-azure.
azure_machine_options = {
  :bootstrap_options => {
    :vm_user => 'localadmin', # Why do I always have to use localadmin?
    :cloud_service_name => node['devstation']['cloud_service'], # 'adamedchefprovisioning', #required
    :storage_account_name => RecipeSettings.attribute_or_env_variable(node, 'storage_account', 'DEVSTATION_STORAGE_ACCOUNT'),
    :vm_size => "Medium", #required
    :location => 'West US', #required
    :tcp_endpoints => '3389:3389', #optional
    :winrm_transport => { #optional
      'https' => { #required (valid values: 'http', 'https')
        :no_ssl_peer_verification => true #optional,(default: false),
      }
    }
  },
  :password => RecipeSettings.attribute_or_env_variable(node, 'user_secret', 'DEVSTATION_USER_SECRET'), #required
  :image_id => 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201502.01-en.us-127GB.vhd'
}

machine node['devstation']['workstation_name'] do
  machine_options azure_machine_options
  recipe 'devbox'
  recipe 'myemacs'
end


