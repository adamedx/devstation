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
  def self.attribute_or_env_variable(node, attribute_name, variable_name, default_value = nil)
    result = node['devstation'][attribute_name]

    if result.nil? || result.length < 1
      value = ENV[variable_name]
      result = ( value.nil? || value.length <= 0 ) ? default_value : value
    end
    if result.nil?
      raise "Neither the cookbook attribute '#{attribute_name}' or the environment variable #{variable_name} is set -- you must configure the setting to run the recipe."
    end
    result
  end

  def self.validate_mandatory_setting!(node, attribute_name, variable_name)
    value = attribute_or_env_variable(node, attribute_name, variable_name)
  end
end
