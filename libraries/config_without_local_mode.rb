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

require 'chef/workstation_config_loader'

# Save the current config which is probably affected by
# local mode overrides instead of a pure knife.rb
current_config = Chef::Config

# Remove the Chef::Config constant and reload the config
# as if local mode had not overridden keys such as the
# chef_server_url. We have to tell Ruby to forget that
# the class that defines config was loaded already so
# it can be reloaded and re-read the config.
Chef.send(:remove_const, 'Config')
$LOADED_FEATURES.delete($LOADED_FEATURES.find { | feature | feature.end_with?('chef/config.rb') })
require 'chef/config'

# Load the config that is now pointing at the original
# config unmodified by local mode overrides
loader = Chef::WorkstationConfigLoader.new(nil, nil)
loader.load

# Save this original configuration
DEVSTATION_NO_LOCAL_MODE_CONFIG = Chef::Config

# Now restore the config that chef-client
# was started with
Chef.send(:remove_const, 'Config')
Chef.const_set('Config', current_config)

class ConfigWithoutLocalMode
  @@config ||= DEVSTATION_NO_LOCAL_MODE_CONFIG

  # Retrieve the pure knife config without overrides
  # from local mode
  def self.workstation_config
    @@config
  end
end

