# copyright: 2018, The Authors

# Test values

resource_group1 = 'storage-account-test-advanced'
stg_account_name_1 = 'softcatadvtest'

describe azurerm_storage_account(resource_group: resource_group1, name: stg_account_name_1) do
  it { should exist }
end

describe azure_storage_account_blob_container(resource_group: resource_group1, storage_account_name: stg_account_name_1, name: 'softcat-container-test-advanced')  do
  it { should exist }
  its('properties') { should have_attributes(publicAccess: 'None') }
end


