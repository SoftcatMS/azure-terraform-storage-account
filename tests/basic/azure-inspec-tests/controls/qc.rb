# copyright: 2018, The Authors

# Test values

resource_group1 = 'storage-account-test-basic'


describe azurerm_storage_account(resource_group: resource_group1, name: 'softcatbasictest') do
  it { should exist }
end

describe azure_storage_account_blob_container(resource_group: resource_group1, storage_account_name: 'softcatbasictest', name: 'softcat-container-test-basic')  do
  it { should exist }
end


