import pytest
import tftest
from pathlib import Path

DIRECTORY = Path(__file__).parent.parent / "examples/default"
TF_VARS_FILE = "env.tfvars"
VALID_SPOKE_VNET_NAME = 'org-vnet-spoke-pd-eus-01'

@pytest.fixture(scope="module")
def plan():
    tf = tftest.TerraformTest(DIRECTORY)
    tf.setup()
    return tf.plan(output=True, tf_var_file=TF_VARS_FILE)


def test_spoke_vnet_name(plan):
    module = plan.modules['module.vnet-spoke']
    source_vnet_resource = module.resources['azurerm_virtual_network.vnet']
    assert source_vnet_resource['values']['name'] == VALID_SPOKE_VNET_NAME