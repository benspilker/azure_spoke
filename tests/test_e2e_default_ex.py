import pytest
import tftest
from pathlib import Path
from azure.identity import DefaultAzureCredential
from azure.mgmt.network import NetworkManagementClient

TOKEN_CREDENTIAL = DefaultAzureCredential()
DIRECTORY = Path(__file__).parent.parent / "examples/default"
TF_VARS_FILE = "env.tfvars"

def check_connected_peering(subscription_id, rg_name, vnet_name, peer_name, remote_vnet_name):
    nmc = NetworkManagementClient(TOKEN_CREDENTIAL, subscription_id)
    nmc.virtual_networks.get(rg_name, vnet_name) # Check if VNet Exists
    peering = nmc.virtual_network_peerings.get(rg_name, vnet_name, peer_name) # Check if Peer Exists
    return ((peering.peering_state == 'Connected') and (peering.remote_virtual_network.id.split('/')[-1] == remote_vnet_name)) # Check that the peer is connected and to the expected target

@pytest.fixture(scope="module")
def output():
    tf = tftest.TerraformTest(DIRECTORY)
    tf.setup()
    try:
        tf.apply(output=True, tf_var_file=TF_VARS_FILE)
        yield tf.output()
    finally:
        tf.destroy(auto_approve=True, tf_var_file=TF_VARS_FILE)

def test_network_interconnect(output):
    #pytest.set_trace() # Uncomment to debug
    assert check_connected_peering(output['spoke_vnet_id'].split('/')[2],output['spoke_vnet_id'].split('/')[4],output['spoke_vnet_name'],output['spoke_to_hub_peer_name'],output['connecting_hub_vnet_name']) # Source to Dest Check
    assert check_connected_peering(output['connecting_hub_subscription_id'],output['connecting_hub_resource_group_name'],output['connecting_hub_vnet_name'],output['hub_to_spoke_peer_name'],output['spoke_vnet_name']) # Dest to Source Check