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

class RecipeSettings

  def initialize(node)
    @node = node
    @settings = {
      'user_secret' => [ 'DEVSTATION_USER_SECRET', nil ],
      'storage_account' => [ 'DEVSTATION_STORAGE_ACCOUNT', nil ],
      'workstation_name' => [ 'DEVSTATION_WORKSTATION_NAME', 'devstation' ],
      'image_id' => [ 'DEVSTATION_IMAGE_ID', 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201502.01-en.us-127GB.vhd' ],
      'location' => [ 'DEVSTATION_LOCATION', 'West US' ],
      'vm_size' => [ 'DEVSTATION_VM_SIZE', 'Medium' ],
      'tcp_endpoints' => [ 'DEVSTATION_TCP_ENDPOINTS', '' ],
      'transport' => [ 'DEVSTATION_TRANSPORT', :winrm ],
      'cloud_service' => [ nil, nil ]
    }
  end

  def value_of(attribute_name, default_value = nil)
    variable_name = @settings[attribute_name][0]
    result = @node['devstation'][attribute_name]

    if result.nil? || result.length < 1
      value = variable_name.nil? ? nil : ENV[variable_name]
      result = ( value.nil? || value.length <= 0 ) ? default_value : value
    end
    if result.nil?
      raise "Neither the cookbook attribute '#{attribute_name}' or the environment variable #{variable_name} is set -- you must configure the setting to run the recipe."
    end
    result
  end

  def validate_mandatory_setting!(attribute_name)
    value_of(attribute_name)
  end

end
