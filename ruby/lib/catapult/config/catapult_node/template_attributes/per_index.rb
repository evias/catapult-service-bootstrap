#    Copyright 2018 Tech Bureau, Corp
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
module Catapult
  class Config::CatapultNode
    class TemplateAttributes
      class PerIndex
        PEER_CONFIG_API_PORT = 7901
        def initialize(parent, index)
          @parent = parent
          @index  = index
          @type   = parent.type
        end

        # TODO: this should be calculeted
        TOTAL_CHAIN_IMPORTANCE = "800'000" # the sum of the currency harvesting amounts should be a power of ten of this

        CURRENCY_MOSAIC_ID     = "0x5B6B'5282'5A09'2704" # this get overwritten so the exact value makes no difference
        HARVESTING_MOSAIC_ID   = "0x468A'5847'D783'45DA" # this get overwritten so the exact value makes no difference
        def hash
          {
            # TODO: move these to seperate config file
            should_enable_verifiable_state: true,
            should_enable_verifiable_receipts: true,
            should_use_cache_database_storage: true,

            total_chain_importance: TOTAL_CHAIN_IMPORTANCE,
            currency_mosaic_id: CURRENCY_MOSAIC_ID,
            harvesting_mosaic_id: HARVESTING_MOSAIC_ID,

            network_identifier: Global.catapult_nework_identifier,
            network_public_key: self.parent.network_public_key,
            network_generation_hash: self.parent.network_generation_hash,
            harvesting_is_on: self.harvesting_is_on?,
            harvest_key: self.harvest_key?,
            mongo_host: self.mongo_host_for_api_node, # just used when there is an api host
            bootkey: self.private_key,
            api_port: PEER_CONFIG_API_PORT,
            port: Peer.port(self.type),
            host: Peer.host(self.type, self.index),
            friendly_name: Peer.name(self.type, self.index),
          }
        end
        
        protected
        
        attr_reader :parent, :index, :type
        
        def mongo_host_for_api_node
          Global.mongo_host
        end

        def harvesting_is_on?
            # TODO: simple strategy that just turns on harvesting for first peer node
          self.type == :peer_node and self.index  == 0
        end
        
        def harvest_key?
          harvest_key if harvesting_is_on? 
        end
        
        def private_key
          self.parent.component_keys.get_key(:private, self.type, self.index)
        end

        private
        
        def harvest_key
          fail "Only should have harvesting on peer_node" unless self.type  == :peer_node 
          self.parent.harvest_keys[self.index] || fail("Do not have a harvest key for index #{self.index}")
        end
        
      end
    end
  end        
end


 

