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

RecipeSettings.validate_mandatory_setting!(node, 'user_secret', 'DEVSTATION_USER_SECRET')
RecipeSettings.validate_mandatory_setting!(node, 'storage_account', 'DEVSTATION_STORAGE_ACCOUNT')

machine_name = RecipeSettings.attribute_or_env_variable(node, 'workstation_name', 'DEVSTATION_WORKSTATION_NAME', 'devstation')
image_id = RecipeSettings.attribute_or_env_variable(node, 'image_id', 'DEVSTATION_IMAGE_ID', 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201502.01-en.us-127GB.vhd')
location = RecipeSettings.attribute_or_env_variable(node, 'location', 'DEVSTATION_LOCATION', 'West US')
vm_size = RecipeSettings.attribute_or_env_variable(node, 'vm_size', 'DEVSTATION_VM_SIZE', 'Medium')
tcp_endpoints = RecipeSettings.attribute_or_env_variable(node, 'tcp_endpoints', 'DEVSTATION_TCP_ENDPOINTS', '')
transport = RecipeSettings.attribute_or_env_variable(node, 'transport', 'DEVSTATION_TRANSPORT', :winrm)

cloud_service = node['devstation']['cloud_service'] || machine_name

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
    :cloud_service_name => machine_name,
    :storage_account_name => RecipeSettings.attribute_or_env_variable(node, 'storage_account', 'DEVSTATION_STORAGE_ACCOUNT'), # required
    :vm_size => vm_size, # required
    :location => location, # required
    :tcp_endpoints => tcp_endpoints, # optional, e.g. '3389:3389'
    :winrm_transport => (transport != :winrm) ? nil : { # optional
      'https' => { # required (valid values: 'http', 'https')
        :no_ssl_peer_verification => true # optional,(default: false),
      }
    }
  },
  :password => RecipeSettings.attribute_or_env_variable(node, 'user_secret', 'DEVSTATION_USER_SECRET'), # required
  :image_id => image_id # required
}

machine_name = RecipeSettings.attribute_or_env_variable(node, 'workstation_name', 'DEVSTATION_WORKSTATION_NAME', 'devstation')

machine machine_name do
  machine_options azure_machine_options
  recipe 'devbox'
  recipe 'myemacs'
  retries 3
end


